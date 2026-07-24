import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Parse form data
    const formData    = await req.formData();
    const file        = formData.get("file") as File;
    const name        = formData.get("name") as string;
    const age         = formData.get("age") as string;
    const start_time  = formData.get("start_time") as string; // "09:00:00"
    const end_time    = formData.get("end_time") as string;   // "17:00:00"
    const pharmacy_id = formData.get("pharmacy_id") as string;
    const phone       = formData.get("phone") as string;

    // Validate required fields
    if (!name || !pharmacy_id) {
      return new Response(
        JSON.stringify({ error: "name and pharmacy_id are required" }),
        { status: 400 }
      );
    }

    // ── Step 1: Upload image if provided ──────────────────────────────────────
    let imageUrl: string | null = null;

    if (file) {
      const cleanName = file.name
        .replace(/\s+/g, "_")
        .replace(/[^a-zA-Z0-9._-]/g, "");
      const fileName = `${Date.now()}_${cleanName}`;

      const { error: uploadError } = await supabase.storage
        .from("pharmacy-images")
        .upload(`employees/${fileName}`, file, {
          contentType: file.type,
        });

      if (uploadError) {
        return new Response(
          JSON.stringify({ error: `Image upload failed: ${uploadError.message}` }),
          { status: 400 }
        );
      }

      const { data: publicUrlData } = supabase.storage
        .from("pharmacy-images")
        .getPublicUrl(`employees/${fileName}`);

      imageUrl = publicUrlData.publicUrl;
    }

    // ── Step 2: Insert into pharmacy_employee ─────────────────────────────────
    const { data: employee, error: employeeError } = await supabase
      .from("pharmacy_employee")
      .insert([
        {
          name,
          age: age ? parseInt(age) : null,
          start_time: start_time || null,
          end_time: end_time || null,
          phone: phone || null,
          image: imageUrl,
        },
      ])
      .select()
      .single();

    if (employeeError) {
      // Cleanup image if employee insert fails
      if (imageUrl) {
        const fileName = imageUrl.split("/").pop()!;
        await supabase.storage
          .from("pharmacy-images")
          .remove([`employees/${fileName}`]);
      }
      return new Response(
        JSON.stringify({ error: `Employee insert failed: ${employeeError.message}` }),
        { status: 400 }
      );
    }

    // ── Step 3: Insert into pharmacy_employee_rel ─────────────────────────────
    const { data: rel, error: relError } = await supabase
      .from("pharmacy_employee_rel")
      .insert([
        {
          pharmacy_id: parseInt(pharmacy_id),
          employee_id: employee.id,
        },
      ])
      .select()
      .single();

    if (relError) {
      // Cleanup employee record and image if rel insert fails
      await supabase.from("pharmacy_employee").delete().eq("id", employee.id);
      if (imageUrl) {
        const fileName = imageUrl.split("/").pop()!;
        await supabase.storage
          .from("pharmacy-images")
          .remove([`employees/${fileName}`]);
      }
      return new Response(
        JSON.stringify({ error: `Relation insert failed: ${relError.message}` }),
        { status: 400 }
      );
    }

    return new Response(
      JSON.stringify({ success: true, employee, rel }),
      { status: 200 }
    );

  } catch (e) {
    return new Response(
      JSON.stringify({ error: e.message }),
      { status: 500 }
    );
  }
});