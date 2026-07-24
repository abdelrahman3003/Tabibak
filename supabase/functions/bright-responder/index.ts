import { serve } from "https://deno.land/std/http/server.ts";
import * as jose from "npm:jose";

// =========================
// GET FIREBASE ACCESS TOKEN
// =========================
async function getAccessToken() {
  const serviceAccount = JSON.parse(
    Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!
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
  return data.access_token;
}

// =========================
// ARABIC NOTIFICATION TEXT
// =========================
function getNotificationText(name: string, status: number) {
  switch (status) {
    case 1:
      return {
        title: "📅 موعد جديد",
        body: `قام ${name} بحجز موعد جديد`,
      };
    case 2:
      return {
        title: "✅ تأكيد الموعد",
        body: `تم تأكيد موعد ${name}`,
      };
    case 3:
      return {
        title: "❌ إلغاء الموعد",
        body: `قام ${name} بإلغاء الموعد`,
      };
    default:
      return {
        title: "📋 تحديث الموعد",
        body: `تم تحديث موعد ${name}`,
      };
  }
}

// =========================
// MAIN HANDLER
// =========================
serve(async (req) => {
  try {
    // ✅ Extract all fields including shift IDs
    const {
      appointment_date,
      doctor_id,
      user_id,
      status,
      phone,
      name,
      description,
      shift_morning_id,  // ✅ added
      shift_evening_id,  // ✅ added
    } = await req.json();

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const projectId = Deno.env.get("FIREBASE_PROJECT_ID")!;

    // =========================
    // 1. INSERT APPOINTMENT
    // =========================
    const insertRes = await fetch(`${supabaseUrl}/rest/v1/appointments`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        apikey: supabaseKey,
        Authorization: `Bearer ${supabaseKey}`,
        Prefer: "return=representation",
      },
      body: JSON.stringify({
        appointment_date,
        doctor_id,
        user_id,
        status,
        phone,
        name,
        description,
        appointment_morning_shift_id: shift_morning_id ?? null,  // ✅ matches DB column
        appointment_evening_shift_id: shift_evening_id ?? null,  // ✅ matches DB column
      }),
    });

    const inserted = await insertRes.json();

    if (!insertRes.ok) {
      return new Response(
        JSON.stringify({ success: false, stage: "database", error: inserted }),
        { status: 500 }
      );
    }

    // =========================
    // 2. GET DOCTOR FCM TOKEN
    // =========================
    const doctorRes = await fetch(
      `${supabaseUrl}/rest/v1/doctors?doctor_id=eq.${doctor_id}&select=fcm_token`,
      {
        headers: {
          apikey: supabaseKey,
          Authorization: `Bearer ${supabaseKey}`,
        },
      }
    );

    const doctorData = await doctorRes.json();
    const doctorToken = doctorData?.[0]?.fcm_token;

    if (!doctorToken) {
      return new Response(
        JSON.stringify({
          success: true,
          data: inserted,
          message: "No FCM token for doctor",
        }),
        { status: 200 }
      );
    }

    // =========================
    // 3. SEND ARABIC NOTIFICATION
    // =========================
    const accessToken = await getAccessToken();
    const { title, body } = getNotificationText(name, status); // ✅ Arabic text

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
            token: doctorToken,
            notification: { title, body },
            android: {
              notification: {
                title,
                body,
                default_sound: true,
              },
            },
            apns: {
              payload: {
                aps: {
                  alert: { title, body },
                  sound: "default",
                },
              },
            },
          },
        }),
      }
    );

    const fcmData = await fcmRes.json();

    return new Response(
      JSON.stringify({ success: true, data: inserted, notification: fcmData }),
      { headers: { "Content-Type": "application/json" } }
    );
  } catch (err) {
    return new Response(
      JSON.stringify({ success: false, error: err.message }),
      { status: 500 }
    );
  }
});