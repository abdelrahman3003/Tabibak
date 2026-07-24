import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Parse form data
    const formData = await req.formData();
    const file        = formData.get("file") as File;
    const name        = formData.get("name") as string;
    const address_ar  = formData.get("address_ar") as string;
    const address_en  = formData.get("address_en") as string;
    const time_start  = formData.get("time_start") as string; // "09:00:00"
    const time_end    = formData.get("time_end") as string;   // "22:00:00"
    const doctor_name = formData.get("doctor_name") as string;

    // Validate required fields
    if (!file || !name || !address_ar || !address_en || !time_start || !time_end || !doctor_name) {
      return new Response(
        JSON.stringify({
          error: "All fields are required: file, name, address_ar, address_en, time_start, time_end, doctor_name",
        }),
        { status: 400 }
      );
    }

    // Upload image to storage bucket
    const cleanName = file.name
      .replace(/\s+/g, "_")
      .replace(/[^a-zA-Z0-9._-]/g, "");
    const fileName = `${Date.now()}_${cleanName}`;

    const { error: uploadError } = await supabase.storage
      .from("pharmacy-images")
      .upload(fileName, file, {
        contentType: file.type,
      });

    if (uploadError) {
      return new Response(
        JSON.stringify({ error: `Image upload failed: ${uploadError.message}` }),
        { status: 400 }
      );
    }

    // Get public URL of uploaded image
    const { data: publicUrlData } = supabase.storage
      .from("pharmacy-images")
      .getPublicUrl(fileName);

    const imageUrl = publicUrlData.publicUrl;

    // Insert pharmacy record into DB
    const { data, error } = await supabase
      .from("pharmacies")
      .insert([
        {
          name,
          address_ar,
          address_en,
          image: imageUrl,
          time_start,
          time_end,
          doctor_name,
        },
      ])
      .select()
      .single();

    if (error) {
      // Cleanup uploaded image if DB insert fails
      await supabase.storage.from("pharmacy-images").remove([fileName]);
      return new Response(
        JSON.stringify({ error: `Database insert failed: ${error.message}` }),
        { status: 400 }
      );
    }

    return new Response(
      JSON.stringify({ success: true, data, imageUrl }),
      { status: 200 }
    );

  } catch (e) {
    return new Response(
      JSON.stringify({ error: e.message }),
      { status: 500 }
    );
  }
});