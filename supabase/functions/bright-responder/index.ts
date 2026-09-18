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

    // 1. INSERT APPOINTMENT (DB truth columns)
    const insertRes = await fetch(`${supabaseUrl}/rest/v1/appointments`, {
      method: "POST",
      headers: { ...rest, Prefer: "return=representation" },
      body: JSON.stringify({
        appointment_date,
        doctor_id,
        user_id,
        status,
        phone,
        name,
        description: description ?? null,
        appointment_morning_shift_id: shift_morning_id ?? null,
        appointment_evening_shift_id: shift_evening_id ?? null,
        appointment_type,
      }),
    });
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
    const patientTitle = "تم استلام طلب الحجز";
    const patientBody =
      `تم حجز موعدك بتاريخ ${appointment_date} وهو الآن قيد الانتظار`;
    try {
      const inboxRes = await fetch(`${supabaseUrl}/rest/v1/notifications`, {
        method: "POST",
        headers: { ...rest, Prefer: "return=representation" },
        body: JSON.stringify({
          user_id,
          title: patientTitle,
          body: patientBody,
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
    const doctorToken = doctorJson?.[0]?.fcm_token;
    const patientToken = userJson?.[0]?.fcm_token;

    let accessToken: string | null = null;
    try {
      accessToken = await getAccessToken();
    } catch (e) {
      console.log("FCM token error:", e);
    }

    let doctorSent = false;
    let patientSent = false;

    if (accessToken) {
      if (doctorToken) {
        const { title, body } = doctorText(name, status);
        const r = await sendFcm(projectId, accessToken, doctorToken, title, body, {
          appointment_id: String(appointmentId ?? ""),
          type: "appointment",
        });
        doctorSent = r.ok;
      }
      if (patientToken) {
        const r = await sendFcm(
          projectId,
          accessToken,
          patientToken,
          patientTitle,
          patientBody,
          {
            appointment_id: String(appointmentId ?? ""),
            type: "appointment",
            notification_id: patientNotificationId != null
              ? String(patientNotificationId)
              : "",
          },
        );
        patientSent = r.ok;
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        data: appointment,
        notification_id: patientNotificationId,
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
