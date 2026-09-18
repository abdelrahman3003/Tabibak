import { serve } from "https://deno.land/std/http/server.ts";

const ALLOWED_TYPES = new Set([
  "appointment",
  "reminder",
  "cancellation",
  "result",
  "promotion",
  "general",
]);

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { user_id, title, body, data = {}, type = "general" } =
      await req.json();

    if (!user_id || !title || !body) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "user_id, title and body are required",
        }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const notificationType = ALLOWED_TYPES.has(type) ? type : "general";

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const projectId = Deno.env.get("FIREBASE_PROJECT_ID")!;

    const headers = {
      apikey: supabaseKey,
      Authorization: `Bearer ${supabaseKey}`,
      "Content-Type": "application/json",
    };

    // 1. Persist notification first so the inbox works even if FCM fails.
    const insertRes = await fetch(`${supabaseUrl}/rest/v1/notifications`, {
      method: "POST",
      headers: { ...headers, Prefer: "return=representation" },
      body: JSON.stringify({
        user_id,
        title,
        body,
        type: notificationType,
        data,
      }),
    });

    if (!insertRes.ok) {
      const errText = await insertRes.text();
      return new Response(
        JSON.stringify({ success: false, error: `DB insert failed: ${errText}` }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const inserted = (await insertRes.json())?.[0];
    const notificationId = inserted?.id ?? null;

    // 2. Get user FCM token
    const userRes = await fetch(
      `${supabaseUrl}/rest/v1/users?user_id=eq.${user_id}&select=fcm_token`,
      { headers: { apikey: supabaseKey, Authorization: `Bearer ${supabaseKey}` } }
    );

    const user = (await userRes.json())?.[0];

    if (!user?.fcm_token) {
      return new Response(
        JSON.stringify({
          success: true,
          notification_id: notificationId,
          fcm_sent: false,
          error: "No FCM token found (notification saved to inbox)",
        }),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 3. Send FCM
    const accessToken = await getAccessToken();

    const payloadData: Record<string, string> = {};
    for (const [k, v] of Object.entries(data ?? {})) {
      payloadData[k] = String(v);
    }
    payloadData["type"] = notificationType;
    if (notificationId != null) {
      payloadData["notification_id"] = String(notificationId);
    }

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
            notification: { title, body },
            data: payloadData,
            android: { priority: "high" },
            apns: { payload: { aps: { sound: "default" } } },
          },
        }),
      }
    );

    const resultText = await fcmRes.text();

    let result;
    try {
      result = JSON.parse(resultText);
    } catch {
      result = resultText;
    }

    return new Response(
      JSON.stringify({
        success: fcmRes.ok,
        notification_id: notificationId,
        fcm_sent: fcmRes.ok,
        result,
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
      grant_type:
        "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  const data = await res.json();

  if (!data.access_token) {
    throw new Error(JSON.stringify(data));
  }

  return data.access_token;
}

/* =========================
   🔑 PEM Helper
========================= */

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
