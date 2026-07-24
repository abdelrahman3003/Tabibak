import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
  try {
    type DayInput = {
      dayId: number;
      isSelected: boolean;
      morningStart?: string;
      morningEnd?: string;
      eveningStart?: string;
      eveningEnd?: string;
    };

    const { clinicId, selectedDays } = await req.json() as {
      clinicId: number;
      selectedDays: DayInput[];
    };

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    const daysMap = new Map<number, DayInput>(
      selectedDays?.map((d) => [d.dayId, d])
    );

    for (let dayId = 1; dayId <= 7; dayId++) {
      const day = daysMap.get(dayId);
      const isSelected = day?.isSelected ?? false;
      let shiftMorningId: number | null = null;
      let shiftEveningId: number | null = null;

      // get existing working_day to reuse shift IDs
      const { data: existingDay } = await supabase
        .from("working_day")
        .select("shift_morning_id, shift_evening_id")
        .eq("clinic_id", clinicId)
        .eq("day_id", dayId)
        .maybeSingle();

      if (isSelected) {
        // handle morning shift
        if (day?.morningStart && day?.morningEnd) {
          if (existingDay?.shift_morning_id) {
            const { error } = await supabase
              .from("shifts_morning")
              .update({ start: day.morningStart, end: day.morningEnd })
              .eq("id", existingDay.shift_morning_id);
            if (error) throw new Error(`Morning update error: ${error.message}`);
            shiftMorningId = existingDay.shift_morning_id;
          } else {
            const { data: morning, error } = await supabase
              .from("shifts_morning")
              .insert({ start: day.morningStart, end: day.morningEnd })
              .select()
              .single();
            if (error) throw new Error(`Morning insert error: ${error.message}`);
            shiftMorningId = morning.id;
          }
        }

        // handle evening shift
        if (day?.eveningStart && day?.eveningEnd) {
          if (existingDay?.shift_evening_id) {
            const { error } = await supabase
              .from("shift_evening")
              .update({ start: day.eveningStart, end: day.eveningEnd })
              .eq("id", existingDay.shift_evening_id);
            if (error) throw new Error(`Evening update error: ${error.message}`);
            shiftEveningId = existingDay.shift_evening_id;
          } else {
            const { data: evening, error } = await supabase
              .from("shift_evening")
              .insert({ start: day.eveningStart, end: day.eveningEnd })
              .select()
              .single();
            if (error) throw new Error(`Evening insert error: ${error.message}`);
            shiftEveningId = evening.id;
          }
        }
      } else {
        // day deselected — delete orphan shifts if they exist
        if (existingDay?.shift_morning_id) {
          await supabase
            .from("shifts_morning")
            .delete()
            .eq("id", existingDay.shift_morning_id);
        }
        if (existingDay?.shift_evening_id) {
          await supabase
            .from("shift_evening")
            .delete()
            .eq("id", existingDay.shift_evening_id);
        }
      }

      // upsert working_day
      const { error: workingDayError } = await supabase
        .from("working_day")
        .upsert(
          {
            clinic_id: clinicId,
            day_id: dayId,
            is_selected: isSelected,
            shift_morning_id: shiftMorningId,
            shift_evening_id: shiftEveningId,
          },
          { onConflict: "clinic_id,day_id" }
        );
      if (workingDayError) throw new Error(`WorkingDay error: ${workingDayError.message}`);
    }

    return new Response(JSON.stringify({ success: true }), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Function error:", err.message);
    return new Response(
      JSON.stringify({ success: false, error: err.message }),
      { status: 500 }
    );
  }
});