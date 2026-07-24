import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const formData = await req.formData();
    const file = formData.get("file") as File;

    const name = formData.get("name") as string;
    const address = formData.get("address") as string;
    const time_start = formData.get("time_start") as string;
    const time_end = formData.get("time_end") as string;

    const fileName = `${Date.now()}_${file.name}`;

    const { error: uploadError } = await supabase.storage
      .from("pharmacy-images")
      .upload(fileName, file, {
        contentType: file.type,
      });

    if (uploadError) {
      return new Response(JSON.stringify({ error: uploadError.message }), {
        status: 400,
      });
    }

    const { data: publicUrlData } = supabase.storage
      .from("pharmacy-images")
      .getPublicUrl(fileName);

    const imageUrl = publicUrlData.publicUrl;

    const { data, error } = await supabase.from("pharmacy").insert([
      {
        name,
        address,
        image: imageUrl,
        time_start,
        time_end,
      },
    ]).select().single();

    if (error) {
      return new Response(JSON.stringify({ error: error.message }), {
        status: 400,
      });
    }

    return new Response(
      JSON.stringify({
        success: true,
        data,
        imageUrl,
      }),
      { status: 200 }
    );
  } catch (e) {
    return new Response(JSON.stringify({ error: e.message }), {
      status: 500,
    });
  }
});