async function sendNotification({
  token,
  title,
  body,
  projectId,
}: {
  token: string;
  title: string;
  body: string;
  projectId: string;
}) {
  if (!token) return { skipped: true };

  const accessToken = await getAccessToken();

  const res = await fetch(
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
        },
      }),
    }
  );

  return await res.json();
}