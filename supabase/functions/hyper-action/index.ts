import { serve } from "https://deno.land/std/http/server.ts";

serve(async (req) => {
  try {
    const { doctor_id, user_id, status } = await req.json();

    if (![1, 2, 3, 4].includes(status)) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Invalid status (1-4 only)",
        }),
        { status: 400 }
      );
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const projectId = Deno.env.get("FIREBASE_PROJECT_ID")!;

    // 1. update appointment
    const updateRes = await fetch(
      `${supabaseUrl}/rest/v1/appointments?doctor_id=eq.${doctor_id}&user_id=eq.${user_id}`,
      {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          apikey: supabaseKey,
          Authorization: `Bearer ${supabaseKey}`,
        },
        body: JSON.stringify({ status }),
      }
    );

    const updated = await updateRes.json();

    if (!updateRes.ok) {
      return new Response(
        JSON.stringify({ success: false, error: updated }),
        { status: 500 }
      );
    }

    // 2. get user fcm token
    const userRes = await fetch(
      `${supabaseUrl}/rest/v1/users?id=eq.${user_id}&select=fcm_token,name`,
      {
        headers: {
          apikey: supabaseKey,
          Authorization: `Bearer ${supabaseKey}`,
        },
      }
    );

    const userData = await userRes.json();
    const userToken = userData?.[0]?.fcm_token;
    const userName = userData?.[0]?.name;

    // 3. send notification
    if (userToken) {
      await fetch(
        `${supabaseUrl}/functions/v1/send_notification`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            token: userToken,
            title: "Appointment Update",
            body:
              status === 2
                ? "Your appointment is approved"
                : status === 3
                ? "Your appointment was rejected"
                : status === 4
                ? "Your appointment is completed"
                : "Your appointment status updated",
            projectId,
          }),
        }
      );
    }

    return new Response(
      JSON.stringify({
        success: true,
        data: updated,
      }),
      { headers: { "Content-Type": "application/json" } }
    );
  } catch (err) {
    return new Response(
      JSON.stringify({ success: false, error: err.message }),
      { status: 500 }
    );
  }
});