-- Drop old function signatures to prevent overloading conflicts
DROP FUNCTION IF EXISTS public.add_clinic_for_doctor(uuid, text, text, integer, boolean, boolean, bigint, bigint, bigint, bigint, text, text, text);
DROP FUNCTION IF EXISTS public.add_clinic_for_doctor(uuid, text, text, integer, boolean, boolean, bigint, bigint, bigint, bigint, text, text, text, jsonb);

CREATE OR REPLACE FUNCTION public.add_clinic_for_doctor(
  p_doctor_id uuid,
  p_clinic_name text,
  p_phone_number text DEFAULT NULL,
  p_consultation_fee integer DEFAULT 0,
  p_is_booking boolean DEFAULT false,
  p_is_available boolean DEFAULT true,
  -- Address fields
  p_city_id bigint DEFAULT NULL,
  p_markaz_id bigint DEFAULT NULL,
  p_village_id bigint DEFAULT NULL,
  p_governorate_id bigint DEFAULT NULL,
  p_street text DEFAULT NULL,
  p_floor text DEFAULT NULL,
  p_department text DEFAULT NULL,
  -- Schedule / working days array
  p_working_days jsonb DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_clinic public.clinic_data%ROWTYPE;
  v_address public.clinic_address%ROWTYPE;
  v_inserted_working_days jsonb := '[]'::jsonb;
  v_day jsonb;
  v_day_id integer;
  v_is_selected boolean;
  v_morning_start text;
  v_morning_end text;
  v_evening_start text;
  v_evening_end text;
  v_shift_morning_id integer;
  v_shift_evening_id integer;
  v_inserted_day public.working_day%ROWTYPE;
BEGIN
  -- 1. Insert into clinic_data
  INSERT INTO public.clinic_data (
    doctor_id,
    clinic_name,
    phone_number,
    consultation_fee,
    is_booking,
    is_available
  ) VALUES (
    p_doctor_id,
    p_clinic_name,
    p_phone_number,
    COALESCE(p_consultation_fee, 0),
    COALESCE(p_is_booking, false),
    COALESCE(p_is_available, true)
  )
  RETURNING * INTO v_clinic;

  -- 2. Insert into clinic_address if address fields provided
  IF p_city_id IS NOT NULL 
     OR p_markaz_id IS NOT NULL 
     OR p_village_id IS NOT NULL 
     OR p_governorate_id IS NOT NULL 
     OR p_street IS NOT NULL THEN

    INSERT INTO public.clinic_address (
      clinic_id,
      city_id,
      markaz_id,
      village_id,
      governorate_id,
      street,
      floor,
      department
    ) VALUES (
      v_clinic.id,
      p_city_id,
      p_markaz_id,
      p_village_id,
      p_governorate_id,
      p_street,
      p_floor,
      p_department
    )
    RETURNING * INTO v_address;
  END IF;

  -- 3. Insert schedule / working_days if provided
  IF p_working_days IS NOT NULL AND jsonb_typeof(p_working_days) = 'array' THEN
    FOR v_day IN SELECT * FROM jsonb_array_elements(p_working_days)
    LOOP
      v_day_id := COALESCE((v_day->>'day_id')::integer, (v_day->>'dayId')::integer);
      v_is_selected := COALESCE((v_day->>'is_selected')::boolean, (v_day->>'isSelected')::boolean, true);
      
      v_morning_start := COALESCE(v_day->>'morning_start', v_day->>'morningStart');
      v_morning_end   := COALESCE(v_day->>'morning_end', v_day->>'morningEnd');
      v_evening_start := COALESCE(v_day->>'evening_start', v_day->>'eveningStart');
      v_evening_end   := COALESCE(v_day->>'evening_end', v_day->>'eveningEnd');

      v_shift_morning_id := NULL;
      v_shift_evening_id := NULL;

      -- Morning shift
      IF v_morning_start IS NOT NULL AND v_morning_end IS NOT NULL THEN
        INSERT INTO public.shifts_morning (start, "end")
        VALUES (v_morning_start::time, v_morning_end::time)
        RETURNING id INTO v_shift_morning_id;
      END IF;

      -- Evening shift
      IF v_evening_start IS NOT NULL AND v_evening_end IS NOT NULL THEN
        INSERT INTO public.shift_evening (start, "end")
        VALUES (v_evening_start::time, v_evening_end::time)
        RETURNING id INTO v_shift_evening_id;
      END IF;

      -- Working day
      IF v_day_id IS NOT NULL THEN
        INSERT INTO public.working_day (
          clinic_id,
          day_id,
          is_selected,
          shift_morning_id,
          shift_evening_id
        ) VALUES (
          v_clinic.id,
          v_day_id,
          v_is_selected,
          v_shift_morning_id,
          v_shift_evening_id
        )
        RETURNING * INTO v_inserted_day;

        v_inserted_working_days := v_inserted_working_days || jsonb_build_array(to_jsonb(v_inserted_day));
      END IF;
    END LOOP;
  END IF;

  RETURN jsonb_build_object(
    'clinic', to_jsonb(v_clinic),
    'address', to_jsonb(v_address),
    'working_days', v_inserted_working_days
  );
END;
$$;

-- Grant execution permissions
GRANT EXECUTE ON FUNCTION public.add_clinic_for_doctor(uuid, text, text, integer, boolean, boolean, bigint, bigint, bigint, bigint, text, text, text, jsonb) TO authenticated, service_role, anon;

-- Reload schema cache
NOTIFY pgrst, 'reload schema';
