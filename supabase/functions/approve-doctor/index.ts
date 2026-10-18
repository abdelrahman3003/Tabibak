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

    // 1. Fetch the doctor's complete clinic location.
    const clinicRes = await fetch(
      `${supabaseUrl}/rest/v1/clinic_data?doctor_id=eq.${doctorId}&select=id,clinic_name,clinic_address(governorate_id,markaz_id,village_id)`,
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

    // Extract markaz_id and village_id
    let markazId = null;
    let villageId = null;
    let governorateId = null;
    const addressData = clinicData[0].clinic_address;
    if (Array.isArray(addressData) && addressData.length > 0) {
        markazId = addressData[0].markaz_id;
        villageId = addressData[0].village_id;
        governorateId = addressData[0].governorate_id;
    } else if (addressData && !Array.isArray(addressData)) {
        markazId = addressData.markaz_id;
        villageId = addressData.village_id;
        governorateId = addressData.governorate_id;
    }

    // Legacy clinic addresses may only have village_id. Derive its parents.
    if (villageId && (!markazId || !governorateId)) {
      const villageRes = await fetch(
        `${supabaseUrl}/rest/v1/villages?id=eq.${villageId}&select=markaz_id,markaz(governorate_id)`,
        { headers }
      );
      if (villageRes.ok) {
        const village = (await villageRes.json())?.[0];
        markazId ??= village?.markaz_id ?? null;
        const markaz = Array.isArray(village?.markaz) ? village.markaz[0] : village?.markaz;
        governorateId ??= markaz?.governorate_id ?? null;
      }
    }

    if (markazId && !governorateId) {
      const markazRes = await fetch(
        `${supabaseUrl}/rest/v1/markaz?id=eq.${markazId}&select=governorate_id`,
        { headers }
      );
      if (markazRes.ok) governorateId = (await markazRes.json())?.[0]?.governorate_id ?? null;
    }

    if (!governorateId && !markazId && !villageId) {
      return new Response(JSON.stringify({ success: true, message: "Doctor approved, but clinic has no location IDs" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // The most specific doctor location controls the audience. Do not OR all
    // three levels: a village doctor must not notify the whole district.
    const locationType = villageId ? "village" : (markazId ? "markaz" : "governorate");
    const locationId = villageId || markazId || governorateId;
    const locationFilter = locationType === "village"
      ? `village_id.eq.${locationId}`
      : locationType === "markaz"
        ? `markaz_id.eq.${locationId}`
        : `governorate_id.eq.${locationId}`;

    // 2. Notify only users in the selected hierarchy level.
    const usersRes = await fetch(
      `${supabaseUrl}/rest/v1/user_addresses?${locationFilter}&select=user_id`,
      { headers }
    );
    
    if (!usersRes.ok) {
      throw new Error(`Failed to fetch users: ${await usersRes.text()}`);
    }

    const users = await usersRes.json();
    if (!users || users.length === 0) {
      return new Response(JSON.stringify({ success: true, message: "Doctor approved, but no users found in this location" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const userIds = [...new Set(users.map((user: { user_id?: string }) => user.user_id).filter(Boolean))];
    const profilesRes = await fetch(
      `${supabaseUrl}/rest/v1/users?user_id=in.(${userIds.join(",")})&select=user_id,fcm_token`,
      { headers }
    );
    const profiles = profilesRes.ok ? await profilesRes.json() : [];
    const tokensByUser = new Map<string, string>();
    for (const profile of profiles) {
      if (profile.user_id && profile.fcm_token) tokensByUser.set(profile.user_id, profile.fcm_token);
    }

    let formattedDoctorName = doctorName;
    if (!/^(د\.|dr\.|dr |د |دكتور |دكتورة )/i.test(formattedDoctorName) && formattedDoctorName !== "A doctor") {
        if (/^[A-Za-z]/.test(formattedDoctorName)) {
            formattedDoctorName = "Dr. " + formattedDoctorName;
        } else {
            formattedDoctorName = "د. " + formattedDoctorName;
        }
    }

    const locationTable = locationType === "village" ? "villages"
      : locationType === "markaz" ? "markaz" : "governorates";
    const locationRes = await fetch(
      `${supabaseUrl}/rest/v1/${locationTable}?id=eq.${locationId}&select=name_ar`,
      { headers }
    );
    const locationRows = locationRes.ok ? await locationRes.json() : [];
    const locationName = locationRows?.[0]?.name_ar;
    if (!locationName) {
      throw new Error(`Location name not found for ${locationType} ${locationId}`);
    }

    // Use the database name exactly as stored; do not add "مركز" or
    // "محافظة" prefixes. A village name that already contains "قرية"
    // naturally keeps it.
    const title = `تم إضافة دكتور في ${locationName}`;

    const body = `تم إضافة عيادة جديدة: ${clinicName}، خاصة بـ ${formattedDoctorName}.`;
    const notificationType = "promotion";

    // Prepare notifications for insertion and gather tokens
    const notificationsToInsert = [];
    let allTokens = new Set<string>();

    for (const userId of userIds) {
      notificationsToInsert.push({
        user_id: userId,
        title,
        message: body,
        type: notificationType,
        data: { doctor_id: doctorId },
      });

      const token = tokensByUser.get(userId);
      if (token) {
        allTokens.add(token);
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
