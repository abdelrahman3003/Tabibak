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
    const doctorId = payload.doctor_id;

    if (!doctorId) {
      return new Response(JSON.stringify({ success: false, error: "Missing doctor_id" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const projectId = Deno.env.get("FIREBASE_PROJECT_ID")!;

    const headers = {
      apikey: supabaseKey,
      Authorization: `Bearer ${supabaseKey}`,
      "Content-Type": "application/json",
    };

    // 0. Update doctor status to 2 and fetch doctor info
    const updateRes = await fetch(
      `${supabaseUrl}/rest/v1/doctors?doctor_id=eq.${doctorId}&select=doctor_id,name`,
      {
        method: "PATCH",
        headers: { ...headers, "Prefer": "return=representation" },
        body: JSON.stringify({ status: 2 }),
      }
    );

    if (!updateRes.ok) {
        throw new Error(`Failed to update doctor: ${await updateRes.text()}`);
    }

    const updatedDoctors = await updateRes.json();
    if (!updatedDoctors || updatedDoctors.length === 0) {
        throw new Error("Doctor not found or update failed");
    }

    const doctorName = updatedDoctors[0].name || "A doctor";

    // 1. Fetch the doctor's clinic village_id and clinic_name
    const clinicRes = await fetch(
      `${supabaseUrl}/rest/v1/clinic_data?doctor_id=eq.${doctorId}&select=id,clinic_name,clinic_address(village_id)`,
      { headers }
    );
    
    if (!clinicRes.ok) {
      throw new Error(`Failed to fetch clinic data: ${await clinicRes.text()}`);
    }
    
    const clinicData = await clinicRes.json();
    if (!clinicData || clinicData.length === 0) {
       return new Response(JSON.stringify({ success: true, message: "Doctor approved, but no clinic found for doctor" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const clinicName = clinicData[0].clinic_name || "عيادة";

    // Extract village_id (clinic_address could be an array or single object)
    let villageId = null;
    const addressData = clinicData[0].clinic_address;
    if (Array.isArray(addressData) && addressData.length > 0) {
        villageId = addressData[0].village_id;
    } else if (addressData && !Array.isArray(addressData)) {
        villageId = addressData.village_id;
    }

    if (!villageId) {
      return new Response(JSON.stringify({ success: true, message: "Doctor approved, but clinic has no village_id" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // 2. Fetch all users from this village
    const usersRes = await fetch(
      `${supabaseUrl}/rest/v1/users?village_id=eq.${villageId}&select=user_id,fcm_token`,
      { headers }
    );
    
    if (!usersRes.ok) {
      throw new Error(`Failed to fetch users: ${await usersRes.text()}`);
    }

    const users = await usersRes.json();
    if (!users || users.length === 0) {
      return new Response(JSON.stringify({ success: true, message: "Doctor approved, but no users found in this village" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    let formattedDoctorName = doctorName;
    if (!/^(د\.|dr\.|dr |د |دكتور |دكتورة )/i.test(formattedDoctorName) && formattedDoctorName !== "A doctor") {
        if (/^[A-Za-z]/.test(formattedDoctorName)) {
            formattedDoctorName = "Dr. " + formattedDoctorName;
        } else {
            formattedDoctorName = "د. " + formattedDoctorName;
        }
    }

    const title = "عيادة جديدة في قريتك!"; // New clinic in your village!
    const body = `تم إضافة عيادة جديدة: ${clinicName}، خاصة بـ ${formattedDoctorName}.`; // A new clinic has been added: [Clinic Name], owned by Dr. [Doctor Name].
    const notificationType = "promotion";

    // Prepare notifications for insertion and gather tokens
    const notificationsToInsert = [];
    let allTokens = new Set<string>();

    for (const user of users) {
      if (!user.user_id) continue;
      
      notificationsToInsert.push({
        user_id: user.user_id,
        title,
        message: body,
        type: notificationType,
        data: { doctor_id: doctorId },
      });

      if (user.fcm_token) {
        allTokens.add(user.fcm_token);
      }
    }

    // 3. Insert notifications into inbox (batch insert)
    if (notificationsToInsert.length > 0) {
      const insertRes = await fetch(`${supabaseUrl}/rest/v1/notifications`, {
        method: "POST",
        headers,
        body: JSON.stringify(notificationsToInsert),
      });
      if (!insertRes.ok) {
         console.error("Failed to insert notifications:", await insertRes.text());
      }
    }

    // 4. Fetch all user devices for these users
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

    if (tokens.length === 0) {
      return new Response(JSON.stringify({ success: true, message: "Doctor approved, notifications saved to inbox, but no FCM tokens found" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // 5. Send FCM
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
              data: { type: notificationType, doctor_id: String(doctorId) },
              android: { priority: "high" },
              apns: { payload: { aps: { sound: "default" } } },
            },
          }),
        }
      );
      return { ok: fcmRes.ok };
    }));
    
    const sentCount = results.filter((result) => result.ok).length;

    return new Response(
      JSON.stringify({
        success: true,
        message: "Doctor approved and notifications sent",
        devices_targeted: tokens.length,
        devices_sent: sentCount,
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
