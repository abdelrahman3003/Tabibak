import { serve } from "https://deno.land/std@0.224.0/http/mod.ts";
import { getAccessToken } from "./firebase.ts";

serve(async (req) => {
  try {
    const { appointment_id, follow_up_date } = await req.json();
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const projectId = Deno.env.get("FIREBASE_PROJECT_ID")!;

    // 1. Update follow up date
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
        body: JSON.stringify({
          follow_up_date,
          appointment_type: 2,
        }),
      }
    );

    const updated = (await updateRes.json())?.[0];
    if (!updated) {
      return new Response(
        JSON.stringify({ success: false, error: "الموعد غير موجود" }),
        { status: 404 }
      );
    }

    // 2. Get user fcm token
    const userRes = await fetch(
      `${supabaseUrl}/rest/v1/users?user_id=eq.${updated.user_id}&select=fcm_token`,
      {
        headers: {
          apikey: supabaseKey,
          Authorization: `Bearer ${supabaseKey}`,
        },
      }
    );

    const user = (await userRes.json())?.[0];
    let notification_sent = false;

    // 3. Send notification
    if (user?.fcm_token) {
      const accessToken = await getAccessToken();
      const message = `✅ تم تحديد موعد إعادة الكشف بتاريخ ${follow_up_date}`;

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
                title: "موعد متابعة",  // ✅ عربي
                body: message,
              },
              data: {
                appointment_id: String(appointment_id),
                type: "follow_up",
              },
            },
          }),
        }
      );

      notification_sent = fcmRes.ok;
    }

    return new Response(
      JSON.stringify({ success: true, data: updated, notification_sent }),
      { status: 200 }
    );
  } catch (err) {
    return new Response(
      JSON.stringify({ success: false, error: err.message }),
      { status: 500 }
    );
  }
});