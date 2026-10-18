import postgres from "https://deno.land/x/postgresjs@v3.4.4/mod.js";
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

type Location = {
  type: "village" | "markaz" | "governorate";
  id: number;
  name: string;
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return json({ success: false, error: "Method not allowed" }, 405);

  try {
    const payload = await req.json();
    // Accept both { "doctors": [...] } and a raw [...] request body.
    const doctors = Array.isArray(payload) ? payload : payload?.doctors;
    if (!Array.isArray(doctors) || doctors.length === 0) {
      return json({ success: false, error: "doctors must be a non-empty array" }, 400);
    }
    if (doctors.length > 500) {
      return json({ success: false, error: "Maximum 500 doctors per request" }, 400);
    }

    const dbUrl = Deno.env.get("SUPABASE_DB_URL") ?? Deno.env.get("DATABASE_URL");
    if (!dbUrl) throw new Error("SUPABASE_DB_URL is not configured");
    const sql = postgres(dbUrl);
    const created: Array<{ doctor_id: string; location: Location }> = [];
    const failures: Array<{ index: number; error: string }> = [];

    try {
      for (let index = 0; index < doctors.length; index++) {
        const item = doctors[index];
        try {
          const doctor = item?.doctor;
          const clinic = item?.clinic;
          const address = clinic?.clinic_address ?? clinic?.address ?? {};
          if (!doctor?.name || !doctor?.phone || doctor?.specialty == null || !doctor?.bio_ar) {
            throw new Error("doctor.name, phone, specialty and bio_ar are required");
          }

          const governorateId = numberOrNull(address.governorate_id);
          const markazId = numberOrNull(address.markaz_id);
          const villageId = numberOrNull(address.village_id);
          if (!governorateId && !markazId && !villageId) {
            throw new Error("clinic location requires governorate_id, markaz_id, or village_id");
          }

          const result = await sql.begin(async (tx) => {
            const doctorId = crypto.randomUUID();
            const [newDoctor] = await tx`
              INSERT INTO doctors (doctor_id, name, phone, specialty, bio_ar, bio_en, image, email, status)
              VALUES (${doctorId}, ${doctor.name}, ${doctor.phone}, ${doctor.specialty}, ${doctor.bio_ar},
                ${doctor.bio_en ?? null}, ${doctor.image ?? null}, ${doctor.email ?? null}, 2)
              RETURNING doctor_id
            `;
            const [newClinic] = await tx`
              INSERT INTO clinic_data (doctor_id, is_booking, is_available, clinic_name, phone_number, consultation_fee)
              VALUES (${doctorId}, ${clinic?.is_booking ?? false}, ${clinic?.is_available ?? true},
                ${address.clinic_name ?? clinic?.clinic_name ?? null},
                ${address.phone_number ?? clinic?.phone_number ?? doctor.phone},
                ${clinic?.consultation_fee ?? clinic?.fee ?? doctor.fee ?? null})
              RETURNING id
            `;
            await tx`
              INSERT INTO clinic_address (clinic_id, governorate_id, markaz_id, village_id, street, floor, department)
              VALUES (${newClinic.id}, ${governorateId}, ${markazId}, ${villageId},
                ${address.street ?? null}, ${address.floor ?? null}, ${address.department ?? null})
            `;
            return { doctorId: newDoctor.doctor_id };
          });

          const location = await resolveLocation(sql, governorateId, markazId, villageId);
          created.push({ doctor_id: result.doctorId, location });
        } catch (error) {
          failures.push({ index, error: error instanceof Error ? error.message : String(error) });
        }
      }
    } finally {
      await sql.end({ timeout: 5 });
    }

    const notifications = await sendAggregatedNotifications(created);
    return json({
      success: failures.length === 0,
      created_count: created.length,
      approved_count: created.length,
      failed_count: failures.length,
      doctors: created.map((item) => item.doctor_id),
      failures,
      notifications,
    }, failures.length === 0 ? 200 : 207);
  } catch (error) {
    return json({ success: false, error: error instanceof Error ? error.message : String(error) }, 500);
  }
});

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function numberOrNull(value: unknown): number | null {
  if (value === null || value === undefined || value === "") return null;
  const number = Number(value);
  if (!Number.isInteger(number) || number <= 0) throw new Error(`Invalid location ID: ${value}`);
  return number;
}

async function resolveLocation(sql: any, governorateId: number | null, markazId: number | null, villageId: number | null): Promise<Location> {
  if (villageId) {
    const rows = await sql`SELECT id, name_ar AS name FROM villages WHERE id = ${villageId}`;
    if (!rows[0]?.name) throw new Error(`Village ${villageId} not found`);
    return { type: "village", id: villageId, name: rows[0].name };
  }
  if (markazId) {
    const rows = await sql`SELECT id, name_ar AS name FROM markaz WHERE id = ${markazId}`;
    if (!rows[0]?.name) throw new Error(`Markaz ${markazId} not found`);
    return { type: "markaz", id: markazId, name: rows[0].name };
  }
  const rows = await sql`SELECT id, name_ar AS name FROM governorates WHERE id = ${governorateId}`;
  if (!rows[0]?.name) throw new Error(`Governorate ${governorateId} not found`);
  return { type: "governorate", id: governorateId!, name: rows[0].name };
}

async function sendAggregatedNotifications(items: Array<{ doctor_id: string; location: Location }>) {
  if (items.length === 0) return { locations: 0, users: 0, devices_sent: 0 };
  const groups = new Map<string, { location: Location; doctor_ids: string[] }>();
  for (const item of items) {
    const key = `${item.location.type}:${item.location.id}`;
    const group = groups.get(key) ?? { location: item.location, doctor_ids: [] };
    group.doctor_ids.push(item.doctor_id);
    groups.set(key, group);
  }

  const url = Deno.env.get("SUPABASE_URL")!;
  const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const headers = { apikey: key, Authorization: `Bearer ${key}`, "Content-Type": "application/json" };
  const projectId = Deno.env.get("FIREBASE_PROJECT_ID")!;
  let userCount = 0;
  let sent = 0;

  for (const group of groups.values()) {
    const filter = `${group.location.type === "village" ? "village" : group.location.type === "markaz" ? "markaz" : "governorate"}_id=eq.${group.location.id}`;
    const usersRes = await fetch(`${url}/rest/v1/user_addresses?${filter}&select=user_id`, { headers });
    if (!usersRes.ok) throw new Error(`Failed to fetch users: ${await usersRes.text()}`);
    const users = await usersRes.json();
    const userIds = [...new Set(users.map((u: { user_id?: string }) => u.user_id).filter(Boolean))] as string[];
    if (userIds.length === 0) continue;
    userCount += userIds.length;
    const title = `تم إضافة ${group.doctor_ids.length} دكاترة في ${group.location.name}`;
    const body = `تمت إضافة ${group.doctor_ids.length} أطباء جدد. يمكنك الآن حجز موعد.`;
    const rows = userIds.map((user_id) => ({
      user_id,
      title,
      message: body,
      type: "promotion",
      data: { doctor_id: group.doctor_ids[0], doctor_ids: group.doctor_ids },
    }));
    const insertRes = await fetch(`${url}/rest/v1/notifications`, {
      method: "POST",
      headers: { ...headers, Prefer: "return=representation" },
      body: JSON.stringify(rows),
    });
    if (!insertRes.ok) throw new Error(`Failed to insert notifications: ${await insertRes.text()}`);
    const inserted = await insertRes.json();
    const notificationId = inserted?.[0]?.id;
    const devicesRes = await fetch(`${url}/rest/v1/user_devices?user_id=in.(${userIds.join(",")})&is_active=eq.true&select=fcm_token`, { headers });
    const devices = devicesRes.ok ? await devicesRes.json() : [];
    const legacyRes = await fetch(`${url}/rest/v1/users?user_id=in.(${userIds.join(",")})&select=fcm_token`, { headers });
    const legacy = legacyRes.ok ? await legacyRes.json() : [];
    const tokens = [...new Set([...devices, ...legacy].map((d: { fcm_token?: string }) => d.fcm_token).filter(Boolean))] as string[];
    if (tokens.length === 0) continue;
    const accessToken = await getAccessToken();
    const results = await Promise.all(tokens.map(async (token) => {
      const fcmRes = await fetch(`https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`, {
      method: "POST",
      headers: { "Content-Type": "application/json", Authorization: `Bearer ${accessToken}` },
        body: JSON.stringify({ message: {
          token,
          notification: { title, body },
          // Keep the same `doctor_id` contract as approve-doctor while also
          // carrying the complete aggregate for clients that support it.
          data: {
            type: "promotion",
            doctor_id: String(group.doctor_ids[0]),
            doctor_ids: group.doctor_ids.join(","),
            ...(notificationId != null ? { notification_id: String(notificationId) } : {}),
          },
          android: { priority: "high" },
          apns: { payload: { aps: { sound: "default" } } },
        } }),
      });
      if (!fcmRes.ok) console.error("Bulk FCM delivery failed:", await fcmRes.text());
      return fcmRes.ok;
    }));
    sent += results.filter((result) => result.ok).length;
  }
  return { locations: groups.size, users: userCount, devices_sent: sent };
}

async function getAccessToken(): Promise<string> {
  const account = JSON.parse(Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!);
  const key = await crypto.subtle.importKey("pkcs8", pemToArrayBuffer(account.private_key.replace(/\\n/g, "\n")), { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" }, false, ["sign"]);
  const encode = (value: object) => btoa(JSON.stringify(value)).replace(/=/g, "").replace(/\+/g, "-").replace(/\//g, "_");
  const now = Math.floor(Date.now() / 1000);
  const unsigned = `${encode({ alg: "RS256", typ: "JWT" })}.${encode({ iss: account.client_email, scope: "https://www.googleapis.com/auth/firebase.messaging", aud: "https://oauth2.googleapis.com/token", iat: now, exp: now + 3600 })}`;
  const signature = await crypto.subtle.sign("RSASSA-PKCS1-v1_5", key, new TextEncoder().encode(unsigned));
  const jwt = `${unsigned}.${btoa(String.fromCharCode(...new Uint8Array(signature))).replace(/=/g, "").replace(/\+/g, "-").replace(/\//g, "_")}`;
  const response = await fetch("https://oauth2.googleapis.com/token", { method: "POST", headers: { "Content-Type": "application/x-www-form-urlencoded" }, body: new URLSearchParams({ grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer", assertion: jwt }) });
  const data = await response.json();
  if (!data.access_token) throw new Error(JSON.stringify(data));
  return data.access_token;
}

function pemToArrayBuffer(pem: string) {
  const binary = atob(pem.replace("-----BEGIN PRIVATE KEY-----", "").replace("-----END PRIVATE KEY-----", "").replace(/\s/g, ""));
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
  return bytes.buffer;
}
