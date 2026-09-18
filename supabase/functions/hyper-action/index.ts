import { serve } from "https://deno.land/std/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json",
};

// DB truth: 1 pending, 2 confirmed, 3 completed, 4 cancelled.
// NOTE: Prefer `update_appointment` (by appointment_id). This function is kept
// for backward compatibility and now also works by single appointment_id.
serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  try {
    const { appointment_id, doctor_id, user_id, status } = await req.json();

    if (![1, 2, 3, 4].includes(status)) {
      return new Response(
        JSON.stringify({ success: false, error: "Invalid status (1-4 only)" }),
        { status: 400, headers: corsHeaders },
      );
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const rest = {
      "Content-Type": "application/json",
      apikey: supabaseKey,
      Authorization: `Bearer ${supabaseKey}`,
    };

    // 1. Update exactly one appointment when id is given; otherwise fall back
    // to the legacy (doctor_id + user_id) filter but only the latest pending.
    let filter: string;
    if (appointment_id != null) {
      filter = `id=eq.${appointment_id}`;
    } else if (doctor_id && user_id) {
      filter = `doctor_id=eq.${doctor_id}&user_id=eq.${user_id}&status=eq.1&order=created_at.desc&limit=1`;
    } else {
      return new Response(
        JSON.stringify({
          success: false,
          error: "appointment_id OR (doctor_id + user_id) required",
        }),
        { status: 400, headers: corsHeaders },
      );
    }

    const updateRes = await fetch(
      `${supabaseUrl}/rest/v1/appointments?${filter}`,
      {
        method: "PATCH",
        headers: { ...rest, Prefer: "return=representation" },
        body: JSON.stringify({ status }),
      },
    );
    const updated = await updateRes.json();
    if (!updateRes.ok) {
      return new Response(
        JSON.stringify({ success: false, error: updated }),
        { status: 500, headers: corsHeaders },
      );
    }
    const appointment = Array.isArray(updated) ? updated[0] : updated;
    if (!appointment) {
      return new Response(
        JSON.stringify({ success: false, error: "Appointment not found" }),
        { status: 404, headers: corsHeaders },
      );
    }

    // 2. Get user token (correct column is user_id, not id)
    const targetUserId = appointment.user_id ?? user_id;
    const userRes = await fetch(
      `${supabaseUrl}/rest/v1/users?user_id=eq.${targetUserId}&select=fcm_token`,
      { headers: { apikey: supabaseKey, Authorization: `Bearer ${supabaseKey}` } },
    );
    const userToken = (await userRes.json())?.[0]?.fcm_token;

    // 3. Persist inbox + delegate FCM to the canonical sender so payloads
    // stay consistent (notification_id in data for deep-link + mark-read).
    const titles: Record<number, string> = {
      1: "موعدك قيد الانتظار",
      2: "تم قبول موعدك بنجاح ✅",
      3: "تم إتمام موعدك ✅",
      4: "تم إلغاء موعدك ❌",
    };
    const types: Record<number, string> = {
      1: "appointment",
      2: "appointment",
      3: "result",
      4: "cancellation",
    };
    const title = "تحديث الموعد";
    const body = titles[status] ?? "تم تحديث موعدك";
    const type = types[status] ?? "general";

    // Canonical sender persists the inbox row + sends FCM (single source of
    // truth, avoids duplicate inbox rows).
    let notification_id: number | null = null;
    let fcm_sent = false;
    {
      const fcmRes = await fetch(
        `${supabaseUrl}/functions/v1/send-notifcation`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            apikey: supabaseKey,
            Authorization: `Bearer ${supabaseKey}`,
          },
          body: JSON.stringify({
            user_id: targetUserId,
            title,
            body,
            type,
            data: {
              appointment_id: String(appointment.id),
              status: String(status),
            },
          }),
        },
      );
      try {
        const parsed = await fcmRes.json();
        notification_id = parsed?.notification_id ?? null;
      } catch (_) {}
      fcm_sent = fcmRes.ok;
    }

    return new Response(
      JSON.stringify({
        success: true,
        data: appointment,
        notification_id,
        fcm_sent,
        fcm_token_found: Boolean(userToken),
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
