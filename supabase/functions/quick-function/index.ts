export default async function sendNotificationForNewDoctor(req, res) {
  const { doctorName } = await req.json();

  // جلب كل FCM Tokens (استبدل بالـ Direct DB call أو client جاهز)
  const users = []; // هنا هتجيب البيانات من Supabase

  // إرسال الإشعارات
  const notifications = users.map(user =>
    fetch("https://fcm.googleapis.com/fcm/send", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `key=YOUR_SERVER_KEY`
      },
      body: JSON.stringify({
        to: user.fcm_token,
        notification: {
          title: "دكتور جديد",
          body: `تم إضافة دكتور جديد: ${doctorName}`,
        },
      }),
    })
  );

  await Promise.all(notifications);
  return new Response(JSON.stringify({ success: true }), { status: 200 });
}
