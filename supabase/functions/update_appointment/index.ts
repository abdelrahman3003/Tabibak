import { serve } from "https://deno.land/std/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json",
};

// DB truth: 1 pending, 2 confirmed, 3 completed, 4 cancelled.
const STATUS_TEXT: Record<number, { body: string; type: string }> = {
  1: { body: "موعدك قيد الانتظار", type: "appointment" },
  2: { body: "تم قبول موعدك بنجاح ✅", type: "appointment" },
  3: { body: "تم إتمام موعدك ✅", type: "result" },
  4: { body: "تم إلغاء موعدك ❌", type: "cancellation" },
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  try {
    const { appointment_id, status } = await req.json();

    if (appointment_id == null || status == null) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "appointment_id and status are required",
        }),
        { status: 400, headers: corsHeaders },
      );
    }
    if (![1, 2, 3, 4].includes(status)) {
      return new Response(
        JSON.stringify({ success: false, error: "Invalid status (1-4 only)" }),
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

    // 1. Get appointment
    const apptRes = await fetch(
      `${supabaseUrl}/rest/v1/appointments?id=eq.${appointment_id}&select=*`,
      { headers: { apikey: supabaseKey, Authorization: `Bearer ${supabaseKey}` } },
    );
    const appointment = (await apptRes.json())?.[0];
    if (!appointment) {
      return new Response(
        JSON.stringify({ success: false, error: "Appointment not found" }),
        { status: 404, headers: corsHeaders },
      );
    }

    // 2. Update appointment
    const updateRes = await fetch(
      `${supabaseUrl}/rest/v1/appointments?id=eq.${appointment_id}`,
      {
        method: "PATCH",
        headers: { ...rest, Prefer: "return=representation" },
        body: JSON.stringify({ status }),
      },
    );
    if (!updateRes.ok) {
      const err = await updateRes.text();
      return new Response(
        JSON.stringify({ success: false, error: `Update failed: ${err}` }),
        { status: 500, headers: corsHeaders },
      );
    }
    const updated = (await updateRes.json())?.[0];

    // 3. Get user
    const userRes = await fetch(
      `${supabaseUrl}/rest/v1/users?user_id=eq.${appointment.user_id}&select=fcm_token,name`,
      { headers: { apikey: supabaseKey, Authorization: `Bearer ${supabaseKey}` } },
    );
    const user = (await userRes.json())?.[0];

    const meta = STATUS_TEXT[status];
    const message: string = meta.body;
    const notificationType = meta.type;
    let notification_id: number | null = null;

    // 4. Persist to inbox so the app list works even if FCM fails
    const insertRes = await fetch(`${supabaseUrl}/rest/v1/notifications`, {
      method: "POST",
      headers: { ...rest, Prefer: "return=representation" },
      body: JSON.stringify({
        user_id: appointment.user_id,
        title: "تحديث الموعد",
        body: message,
        type: notificationType,
        data: {
          appointment_id: String(appointment_id),
          status: String(status),
        },
      }),
    });
    if (insertRes.ok) {
      notification_id = (await insertRes.json())?.[0]?.id ?? null;
    }

    let notification_sent = false;
    let fcm_result: any = null;

    if (user?.fcm_token) {
      try {
        const accessToken = await getAccessToken();
        const fcmRes = await fetch(
          `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${accessToken}`,
            },
            body: JSON.stringify({
              message: {
                token: user.fcm_token,
                notification: { title: "تحديث الموعد", body: message },
                data: {
                  appointment_id: String(appointment_id),
                  status: String(status),
                  type: notificationType,
                  notification_id:
                    notification_id != null ? String(notification_id) : "",
                },
                android: { priority: "high" },
                apns: { payload: { aps: { sound: "default" } } },
              },
            }),
          },
        );
        const fcmText = await fcmRes.text();
        try {
          fcm_result = JSON.parse(fcmText);
        } catch {
          fcm_result = fcmText;
        }
        notification_sent = fcmRes.ok;
      } catch (e: any) {
        fcm_result = e?.message ?? String(e);
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        data: { appointment: updated, notification_sent, fcm_result, notification_id },
        message: notification_sent
          ? "Updated + Notification sent"
          : "Updated (notification saved to inbox)",
      }),
      { status: 200, headers: corsHeaders },
    );
  } catch (err: any) {
    return new Response(
      JSON.stringify({ success: false, error: err?.message ?? String(err) }),
      { status: 500, headers: corsHeaders },
    );
  }
});

/* 🔐 Firebase Access Token */
async function getAccessToken(): Promise<string> {
  const serviceAccount = JSON.parse(Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!);
  const privateKey = serviceAccount.private_key.replace(/\\n/g, "\n");
  const key = await crypto.subtle.importKey(
    "pkcs8",
    pemToArrayBuffer(privateKey),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const encode = (obj: object) =>
    btoa(JSON.stringify(obj)).replace(/=/g, "").replace(/\+/g, "-").replace(
      /\//g,
      "_",
    );
  const now = Math.floor(Date.now() / 1000);
  const unsigned =
    `${encode({ alg: "RS256", typ: "JWT" })}.${encode({
      iss: serviceAccount.client_email,
      scope: "https://www.googleapis.com/auth/firebase.messaging",
      aud: "https://oauth2.googleapis.com/token",
      iat: now,
      exp: now + 3600,
    })}`;
  const sig = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    new TextEncoder().encode(unsigned),
  );
  const signature = btoa(String.fromCharCode(...new Uint8Array(sig)))
    .replace(/=/g, "").replace(/\+/g, "-").replace(/\//g, "_");
  const jwt = `${unsigned}.${signature}`;
  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });
  const data = await res.json();
  if (!data.access_token) throw new Error(JSON.stringify(data));
  return data.access_token;
}

function pemToArrayBuffer(pem: string) {
  const b64 = pem
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\s/g, "");
  const binary = atob(b64);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
  return bytes.buffer;
}
