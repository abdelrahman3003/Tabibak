const SUPABASE_URL = "https://wzfdmzijnyaihssxwril.supabase.co";
const SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6ZmRtemlqbnlhaWhzc3h3cmlsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAwNzY1MDQsImV4cCI6MjA2NTY1MjUwNH0.LtLpGqD0fX2gBFrrIJRAB_KcuoScYwXUayNJrQZEBNw";

async function updateSpecialty() {
  const iconUrl = "https://wzfdmzijnyaihssxwril.supabase.co/storage/v1/object/public/specialistes/dermatology.png";
  
  const res = await fetch(`${SUPABASE_URL}/rest/v1/specialties?id=eq.11`, {
    method: "PATCH",
    headers: {
      apikey: SUPABASE_KEY,
      Authorization: `Bearer ${SUPABASE_KEY}`,
      "Content-Type": "application/json",
      "Prefer": "return=representation"
    },
    body: JSON.stringify({ icon: iconUrl })
  });
  
  if (!res.ok) {
    console.error("Error updating:", await res.text());
  } else {
    console.log("Success:", await res.json());
  }
}
updateSpecialty();
