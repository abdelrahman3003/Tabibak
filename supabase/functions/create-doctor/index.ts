import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import postgres from "https://deno.land/x/postgresjs@v3.4.4/mod.js";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const payload = await req.json();
    const { doctor, clinic, workingDays } = payload;

    // Validate required fields
    if (!doctor || !doctor.name || !doctor.phone || !doctor.specialty || !doctor.bio_ar) {
      return new Response(JSON.stringify({ error: "Missing required doctor fields (name, phone, specialty, bio_ar)" }), { 
        status: 400, 
        headers: { ...corsHeaders, "Content-Type": "application/json" } 
      });
    }

    const databaseUrl = Deno.env.get("SUPABASE_DB_URL") ?? Deno.env.get("DATABASE_URL");
    
    if (!databaseUrl) {
      throw new Error("SUPABASE_DB_URL environment variable is not set. Required for transactions.");
    }

    const sql = postgres(databaseUrl);
    
    // Execute all insertions within a transaction
    const result = await sql.begin(async (sql) => {
      const docId = crypto.randomUUID();
      
      const doctorData = {
        doctor_id: docId,
        name: doctor.name,
        phone: doctor.phone,
        specialty: doctor.specialty,
        bio_ar: doctor.bio_ar,
        status: 1 // 1 for pending, 2 for approved
      };

      // Insert doctor
      const [newDoctor] = await sql`
        INSERT INTO doctors ${sql(doctorData)}
        RETURNING *
      `;

      let newClinic = null;
      let insertedClinicAddress = null;
      let insertedWorkingDays = [];

      // Create a default clinic record since we need it for the address and shifts
      const addressPayload = clinic?.clinic_address;
      
      const clinicData = {
        doctor_id: newDoctor.doctor_id,
        is_booking: true,
        is_available: true,
        clinic_name: addressPayload?.clinic_name ?? null,
        phone_number: addressPayload?.phone_number ?? null
      };

      const [insertedClinic] = await sql`
        INSERT INTO clinic_data ${sql(clinicData)}
        RETURNING *
      `;
      newClinic = insertedClinic;

      // Insert clinic address if provided
      if (clinic && clinic.clinic_address) {
        const addressPayload = clinic.clinic_address;
        const addressData = {
          clinic_id: newClinic.id,
          city_id: addressPayload.city_id ?? null,
          markaz_id: addressPayload.markaz_id ?? null,
          village_id: addressPayload.village_id ?? null,
          governorate_id: addressPayload.governorate_id ?? null,
          floor: addressPayload.floor ?? null,
          street: addressPayload.street ?? null,
          department: addressPayload.department ?? null
        };

        const [newAddress] = await sql`
          INSERT INTO clinic_address ${sql(addressData)}
          RETURNING *
        `;
        insertedClinicAddress = newAddress;
      }

      // Insert working days and shifts
      if (workingDays && Array.isArray(workingDays)) {
        for (const day of workingDays) {
          let morningId = null;
          let eveningId = null;

          if (day.morningStart && day.morningEnd) {
            const shiftData = { start: day.morningStart, end: day.morningEnd };
            const [m] = await sql`
              INSERT INTO shifts_morning ${sql(shiftData)}
              RETURNING id
            `;
            morningId = m.id;
          }

          if (day.eveningStart && day.eveningEnd) {
            const shiftData = { start: day.eveningStart, end: day.eveningEnd };
            const [e] = await sql`
              INSERT INTO shift_evening ${sql(shiftData)}
              RETURNING id
            `;
            eveningId = e.id;
          }

          const workingDayData = {
            clinic_id: newClinic.id,
            day_id: day.dayId,
            is_selected: day.isSelected ?? false,
            shift_morning_id: morningId,
            shift_evening_id: eveningId
          };

          const [insertedDay] = await sql`
            INSERT INTO working_day ${sql(workingDayData)}
            RETURNING *
          `;
          insertedWorkingDays.push(insertedDay);
        }
      }

      return { 
        doctor: newDoctor, 
        clinic: newClinic,
        clinic_address: insertedClinicAddress,
        workingDays: insertedWorkingDays
      };
    });

    await sql.end();

    return new Response(JSON.stringify({ success: true, data: result }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });

  } catch (error) {
    console.error("Transaction Error:", error);
    return new Response(JSON.stringify({ success: false, error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
