import { serve } from "https://deno.land/std/http/server.ts";
import * as jose from "npm:jose";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json",
};

async function getAccessToken() {
  const serviceAccount = JSON.parse(
    Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!,
  );
  const privateKey = serviceAccount.private_key.replace(/\\n/g, "\n");
  const key = await jose.importPKCS8(privateKey, "RS256");

  const jwt = await new jose.SignJWT({
    iss: serviceAccount.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
  })
    .setProtectedHeader({ alg: "RS256", typ: "JWT" })
    .setIssuedAt()
    .setExpirationTime("1h")
    .sign(key);

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  const data = await res.json();
  if (!data.access_token) throw new Error(JSON.stringify(data));
  return data.access_token;
}

function doctorText(name: string, status: number) {
  switch (status) {
    case 1:
      return { title: "📅 موعد جديد", body: `قام ${name} بحجز موعد جديد` };
    case 2:
      return { title: "✅ تأكيد الموعد", body: `تم تأكيد موعد ${name}` };
    case 4:
      return { title: "❌ إلغاء الموعد", body: `قام ${name} بإلغاء الموعد` };
    default:
      return { title: "📋 تحديث الموعد", body: `تم تحديث موعد ${name}` };
  }
}

async function sendFcm(
  projectId: string,
  accessToken: string,
  token: string,
  title: string,
  body: string,
  data: Record<string, string>,
) {
  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        message: {
          token,
          notification: { title, body },
          data,
          android: { priority: "high", notification: { title, body } },
          apns: { payload: { aps: { alert: { title, body }, sound: "default" } } },
        },
      }),
    },
  );
  const text = await res.text();
  try {
    return { ok: res.ok, result: JSON.parse(text) };
  } catch {
    return { ok: res.ok, result: text };
  }
}

async function recipientTokens(
  supabaseUrl: string,
  rest: Record<string, string>,
  userId: string,
  legacyToken?: string | null,
): Promise<string[]> {
  const response = await fetch(
    `${supabaseUrl}/rest/v1/user_devices?user_id=eq.${userId}&is_active=eq.true&select=fcm_token`,
    { headers: rest },
  );
  const devices = response.ok ? await response.json() : [];
  return [...new Set([
    ...(Array.isArray(devices) ? devices.map((device: { fcm_token?: string | null }) => device.fcm_token) : []),
    legacyToken,
  ].filter((token): token is string => typeof token === "string" && token.trim().length > 0))];
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  try {
    const {
      appointment_date,
      doctor_id,
      user_id,
      status = 1,
      phone,
      name,
      description,
      shift_morning_id,
      shift_evening_id,
      appointment_type = 1,
    } = await req.json();

    if (!appointment_date || !doctor_id || !user_id || !name || !phone) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "appointment_date, doctor_id, user_id, name, phone required",
        }),
        { status: 400, headers: corsHeaders },
      );
    }
    if (shift_morning_id == null && shift_evening_id == null) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "shift_morning_id or shift_evening_id required",
        }),
        { status: 400, headers: corsHeaders },
      );
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const projectId = Deno.env.get("FIREBASE_PROJECT_ID")!;
    const rest = {
      "Content-Type": "application/json",
      apikey: supabaseKey,
      Authorization: `Bearer ${supabaseKey}`,
    };

    // 1. Insert and allocate the waiting-list number atomically in Postgres.
    const insertRes = await fetch(
      `${supabaseUrl}/rest/v1/rpc/add_appointment_with_waiting_list`,
      {
        method: "POST",
        headers: rest,
        body: JSON.stringify({
          p_appointment_date: appointment_date,
          p_doctor_id: doctor_id,
          p_user_id: user_id,
          p_status: status,
          p_phone: phone,
          p_name: name,
          p_description: description ?? null,
          p_shift_morning_id: shift_morning_id ?? null,
          p_shift_evening_id: shift_evening_id ?? null,
          p_appointment_type: appointment_type,
        }),
      },
    );
    const inserted = await insertRes.json();
    if (!insertRes.ok) {
      return new Response(
        JSON.stringify({ success: false, stage: "database", error: inserted }),
        { status: 500, headers: corsHeaders },
      );
    }
    const appointment = Array.isArray(inserted) ? inserted[0] : inserted;
    const appointmentId = appointment?.id;

    // 2. INBOX for patient (so notifications screen works even if FCM fails)
    let patientNotificationId: number | null = null;
    let doctorNotificationId: number | null = null;
    const patientTitle = "تم استلام طلب الحجز";
    const patientBody = appointment?.waiting_list != null
      ? `تم استلام طلب حجزك بتاريخ ${appointment_date}. رقمك في قائمة الانتظار: ${appointment.waiting_list}`
      : `تم حجز موعدك بتاريخ ${appointment_date} وهو الآن قيد الانتظار`;
    try {
      const inboxRes = await fetch(`${supabaseUrl}/rest/v1/notifications`, {
        method: "POST",
        headers: { ...rest, Prefer: "return=representation" },
        body: JSON.stringify({
          user_id,
          title: patientTitle,
          message: patientBody,
          type: "appointment",
          data: {
            appointment_id: String(appointmentId ?? ""),
            doctor_id: String(doctor_id ?? ""),
            status: String(status),
          },
        }),
      });
      if (inboxRes.ok) {
        patientNotificationId = (await inboxRes.json())?.[0]?.id ?? null;
      }
    } catch (_) { /* inbox best-effort */ }

    // Give the doctor an inbox notification too, so the booking remains
    // visible after the push is dismissed. The doctor must also have a users
    // row because notifications.user_id references public.users(user_id).
    if (doctor_id !== user_id) {
      const doctorNotification = doctorText(name, status);
      try {
        const inboxRes = await fetch(`${supabaseUrl}/rest/v1/notifications`, {
          method: "POST",
          headers: { ...rest, Prefer: "return=representation" },
          body: JSON.stringify({
            user_id: doctor_id,
            title: doctorNotification.title,
            message: doctorNotification.body,
            type: "appointment",
            data: {
              appointment_id: String(appointmentId ?? ""),
              doctor_id: String(doctor_id),
              user_id: String(user_id),
              status: String(status),
            },
          }),
        });
        if (inboxRes.ok) {
          doctorNotificationId = (await inboxRes.json())?.[0]?.id ?? null;
        }
      } catch (_) { /* inbox best-effort */ }
    }

    // 3. TOKENS
    const [doctorJson, userJson] = await Promise.all([
      fetch(
        `${supabaseUrl}/rest/v1/doctors?doctor_id=eq.${doctor_id}&select=fcm_token`,
        { headers: rest },
      ).then((r) => r.json()).catch(() => []),
      fetch(
        `${supabaseUrl}/rest/v1/users?user_id=eq.${user_id}&select=fcm_token`,
        { headers: rest },
      ).then((r) => r.json()).catch(() => []),
    ]);
    const [doctorTokens, patientTokens] = await Promise.all([
      recipientTokens(supabaseUrl, rest, doctor_id, doctorJson?.[0]?.fcm_token),
      recipientTokens(supabaseUrl, rest, user_id, userJson?.[0]?.fcm_token),
    ]);

    let accessToken: string | null = null;
    try {
      accessToken = await getAccessToken();
    } catch (e) {
      console.log("FCM token error:", e);
    }

    let doctorSent = false;
    let patientSent = false;

    if (accessToken) {
      if (doctorTokens.length > 0) {
        const { title, body } = doctorText(name, status);
        const results = await Promise.all(doctorTokens.map((token) =>
          sendFcm(projectId, accessToken!, token, title, body, {
            appointment_id: String(appointmentId ?? ""),
            type: "appointment",
            notification_id: doctorNotificationId != null
              ? String(doctorNotificationId)
              : "",
          })
        ));
        doctorSent = results.some((r) => r.ok);
      }
      if (patientTokens.length > 0) {
        const results = await Promise.all(patientTokens.map((token) =>
          sendFcm(
            projectId,
            accessToken!,
            token,
            patientTitle,
            patientBody,
            {
              appointment_id: String(appointmentId ?? ""),
              type: "appointment",
              notification_id: patientNotificationId != null
                ? String(patientNotificationId)
                : "",
            },
          )
        ));
        patientSent = results.some((r) => r.ok);
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        data: appointment,
        notification_id: patientNotificationId,
        doctor_notification_id: doctorNotificationId,
        fcm: { doctor_sent: doctorSent, patient_sent: patientSent },
      }),
      { headers: corsHeaders },
    );
  } catch (err: any) {
    return new Response(
      JSON.stringify({ success: false, error: err?.message ?? String(err) }),
      { status: 500, headers: corsHeaders },
    );
  }
});
