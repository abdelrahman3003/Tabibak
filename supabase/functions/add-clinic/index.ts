import { serve } from "https://deno.land/std/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const payload = await req.json();
    const {
      p_doctor_id,
      p_clinic_name,
      p_phone_number,
      p_consultation_fee,
      p_is_booking,
      p_is_available,
      p_markaz_id,
      p_village_id,
      p_street,
      p_floor,
      p_department,
      p_working_days
    } = payload;

    if (!p_doctor_id || !p_clinic_name) {
      return new Response(JSON.stringify({ error: "p_doctor_id and p_clinic_name are required" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const projectId = Deno.env.get("FIREBASE_PROJECT_ID");

    const headers = {
      apikey: supabaseKey,
      Authorization: `Bearer ${supabaseKey}`,
      "Content-Type": "application/json",
    };

    // 1. Call the database RPC function to insert clinic, address, and schedule
    const rpcRes = await fetch(`${supabaseUrl}/rest/v1/rpc/add_clinic_for_doctor`, {
      method: "POST",
      headers,
      body: JSON.stringify({
        p_doctor_id,
        p_clinic_name,
        p_phone_number: p_phone_number ?? null,
        p_consultation_fee: p_consultation_fee ?? 0,
        p_is_booking: p_is_booking ?? false,
        p_is_available: p_is_available ?? true,
        p_markaz_id: p_markaz_id ?? null,
        p_village_id: p_village_id ?? null,
        p_street: p_street ?? null,
        p_floor: p_floor ?? null,
        p_department: p_department ?? null,
        p_working_days: p_working_days ?? null
      }),
    });

    if (!rpcRes.ok) {
      const errText = await rpcRes.text();
      return new Response(JSON.stringify({ error: `Database RPC error: ${errText}` }), {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const rpcData = await rpcRes.json();

    // 2. Fetch doctor name
    let doctorName = "A doctor";
    const docRes = await fetch(`${supabaseUrl}/rest/v1/doctors?doctor_id=eq.${p_doctor_id}&select=name`, { headers });
    if (docRes.ok) {
      const docData = await docRes.json();
      if (docData && docData.length > 0 && docData[0].name) {
        doctorName = docData[0].name;
      }
    }

    let formattedDoctorName = doctorName;
    if (!/^(د\.|dr\.|dr |د |دكتور |دكتورة )/i.test(formattedDoctorName) && formattedDoctorName !== "A doctor") {
      if (/^[A-Za-z]/.test(formattedDoctorName)) {
        formattedDoctorName = "Dr. " + formattedDoctorName;
      } else {
        formattedDoctorName = "د. " + formattedDoctorName;
      }
    }

    // 3. Notification title logic:
    // If village_id is not null -> "عيادة جديدة في [اسم القرية]!"
    // If village_id is null -> "عيادة جديدة في [اسم المركز]!"
    const locationId = p_village_id || p_markaz_id;
    let locationName = "";
    if (locationId) {
      const locationTable = p_village_id ? "villages" : "markaz";
      const cityRes = await fetch(`${supabaseUrl}/rest/v1/${locationTable}?id=eq.${locationId}&select=name_ar`, { headers });
      if (cityRes.ok) {
        const cityData = await cityRes.json();
        if (cityData && cityData.length > 0 && cityData[0].name_ar) {
          locationName = cityData[0].name_ar;
        }
      }
    }

    const title = locationName 
      ? `عيادة جديدة في ${locationName}!`
      : (p_village_id ? "عيادة جديدة في قريتك!" : "عيادة جديدة في مركزك!");

    const body = `تم إضافة عيادة جديدة: ${p_clinic_name}، خاصة بـ ${formattedDoctorName}.`;
    const notificationType = "promotion";

    let notificationsSent = 0;

    // 4. Send notifications to all users with the same markaz
    if (p_markaz_id && projectId) {
      const usersRes = await fetch(
        `${supabaseUrl}/rest/v1/user_addresses?markaz_id=eq.${p_markaz_id}&select=user_id,users(fcm_token)`,
        { headers }
      );

      if (usersRes.ok) {
        const users = await usersRes.json();
        if (users && users.length > 0) {
          const notificationsToInsert = [];
          const allTokens = new Set<string>();

          for (const user of users) {
            if (!user.user_id) continue;
            notificationsToInsert.push({
              user_id: user.user_id,
              title,
              message: body,
              type: notificationType,
              data: { doctor_id: p_doctor_id },
            });
            if (user.users?.fcm_token) allTokens.add(user.users.fcm_token);
          }

          // Insert into notifications inbox table
          if (notificationsToInsert.length > 0) {
            await fetch(`${supabaseUrl}/rest/v1/notifications`, {
              method: "POST",
              headers,
              body: JSON.stringify(notificationsToInsert),
            });
          }

          // Fetch tokens from user_devices table
          const userIdsStr = notificationsToInsert.map(n => n.user_id).join(',');
          if (userIdsStr) {
            const devicesRes = await fetch(
              `${supabaseUrl}/rest/v1/user_devices?user_id=in.(${userIdsStr})&is_active=eq.true&select=fcm_token`,
              { headers }
            );
            if (devicesRes.ok) {
              const devices = await devicesRes.json();
              if (Array.isArray(devices)) {
                devices.forEach((d: any) => {
                  if (d.fcm_token) allTokens.add(d.fcm_token);
                });
              }
            }
          }

          const tokens = Array.from(allTokens);

          // Send FCM pushes
          if (tokens.length > 0) {
            try {
              const accessToken = await getAccessToken();
              const results = await Promise.all(tokens.map(async (token) => {
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
                        token,
                        notification: { title, body },
                        data: { type: notificationType, doctor_id: String(p_doctor_id) },
                        android: { priority: "high" },
                        apns: { payload: { aps: { sound: "default" } } },
                      },
                    }),
                  }
                );
                return { ok: fcmRes.ok };
              }));
              notificationsSent = results.filter(r => r.ok).length;
            } catch (fcmErr) {
              console.error("FCM Send Error:", fcmErr);
            }
          }
        }
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        data: rpcData,
        notification: {
          title,
          body,
          devices_sent: notificationsSent
        }
      }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err: any) {
    return new Response(
      JSON.stringify({ success: false, error: err?.message ?? String(err) }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});

/* =========================
   🔐 Firebase Access Token
========================= */

async function getAccessToken(): Promise<string> {
  const serviceAccount = JSON.parse(
    Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!
  );

  const privateKey = serviceAccount.private_key.replace(/\\n/g, "\n");

  const key = await crypto.subtle.importKey(
    "pkcs8",
    pemToArrayBuffer(privateKey),
    {
      name: "RSASSA-PKCS1-v1_5",
      hash: "SHA-256",
    },
    false,
    ["sign"]
  );

  const encode = (obj: object) =>
    btoa(JSON.stringify(obj))
      .replace(/=/g, "")
      .replace(/\+/g, "-")
      .replace(/\//g, "_");

  const now = Math.floor(Date.now() / 1000);

  const header = {
    alg: "RS256",
    typ: "JWT",
  };

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
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  const data = await res.json();

  if (!data.access_token) {
    throw new Error(JSON.stringify(data));
  }

  return data.access_token;
}

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
