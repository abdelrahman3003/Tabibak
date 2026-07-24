import { serve } from "https://deno.land/std/http/server.ts";

serve(async (req) => {
  try {
    const body = await req.json();
    const { appointment_id, status } = body;

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const projectId = Deno.env.get("FIREBASE_PROJECT_ID")!;

    // 1. Get appointment
    const apptRes = await fetch(
      `${supabaseUrl}/rest/v1/appointments?id=eq.${appointment_id}&select=*`,
      {
        headers: {
          apikey: supabaseKey,
          Authorization: `Bearer ${supabaseKey}`,
        },
      }
    );

    const appointment = (await apptRes.json())?.[0];

    if (!appointment) {
      return new Response(
        JSON.stringify({ success: false, error: "Appointment not found" }),
        { status: 404, headers: { "Content-Type": "application/json" } }
      );
    }

    // 2. Update appointment
    const updateRes = await fetch(
      `${supabaseUrl}/rest/v1/appointments?id=eq.${appointment_id}`,
      {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          apikey: supabaseKey,
          Authorization: `Bearer ${supabaseKey}`,
          Prefer: "return=representation",
        },
        body: JSON.stringify({ status }),
      }
    );

    const updated = (await updateRes.json())?.[0];

    // 3. Get user
    const userRes = await fetch(
      `${supabaseUrl}/rest/v1/users?user_id=eq.${appointment.user_id}&select=fcm_token,name`,
      {
        headers: {
          apikey: supabaseKey,
          Authorization: `Bearer ${supabaseKey}`,
        },
      }
    );

    const user = (await userRes.json())?.[0];

    let notification_sent = false;
    let fcm_result: any = null;

    // 4. Send Arabic notification
    let message: string | null = null;
    if (status === 5) {
      message = "تم قبول موعدك بنجاح ✅";
    } else if (status === 3) {
      message = "تم إلغاء موعدك ❌";
    }

    if (user?.fcm_token && message) {
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
              notification: {
                title: "تحديث الموعد",
                body: message,
              },
              data: {
                appointment_id: String(appointment_id),
                status: String(status),
              },
            },
          }),
        }
      );

      const fcmText = await fcmRes.text();
      try {
        fcm_result = JSON.parse(fcmText);
      } catch {
        fcm_result = fcmText;
      }

      console.log("FCM STATUS:", fcmRes.status);
      console.log("FCM RESPONSE:", fcm_result);

      notification_sent = fcmRes.ok;
    }

    return new Response(
      JSON.stringify({
        success: true,
        data: { appointment: updated, notification_sent, fcm_result },
        message: notification_sent
          ? "Updated + Notification sent"
          : "Updated but notification failed",
      }),
      { status: 200, headers: { "Content-Type": "application/json" } }
    );
  } catch (err) {
    return new Response(
      JSON.stringify({ success: false, error: err.message }),
      { status: 500, headers: { "Content-Type": "application/json" } }
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
    ["sign"]
  );

  const encode = (obj: object) =>
    btoa(JSON.stringify(obj))
      .replace(/=/g, "")
      .replace(/\+/g, "-")
      .replace(/\//g, "_");

  const now = Math.floor(Date.now() / 1000);

  const header = { alg: "RS256", typ: "JWT" };
  const payload = {
    iss: serviceAccount.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  };

  const unsigned = `${encode(header)}.${encode(payload)}`;

  const sig = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    new TextEncoder().encode(unsigned)
  );

  const signature = btoa(String.fromCharCode(...new Uint8Array(sig)))
    .replace(/=/g, "")
    .replace(/\+/g, "-")
    .replace(/\//g, "_");

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

/* 🔑 PEM helper */
function pemToArrayBuffer(pem: string) {
  const b64 = pem
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\s/g, "");

  const binary = atob(b64);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) {
    bytes[i] = binary.charCodeAt(i);
  }
  return bytes.buffer;
}