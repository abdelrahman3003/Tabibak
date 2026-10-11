-- 1. Alter table column default value for clinic_data.is_booking
ALTER TABLE public.clinic_data 
  ALTER COLUMN is_booking SET DEFAULT false;

-- 2. Update the RPC function to default p_is_booking to false
CREATE OR REPLACE FUNCTION public.add_clinic_for_doctor(
  p_doctor_id uuid,
  p_clinic_name text,
  p_phone_number text DEFAULT NULL,
  p_consultation_fee integer DEFAULT 0,
  p_is_booking boolean DEFAULT false,
  p_is_available boolean DEFAULT true,
  p_city_id bigint DEFAULT NULL,
  p_markaz_id bigint DEFAULT NULL,
  p_village_id bigint DEFAULT NULL,
  p_governorate_id bigint DEFAULT NULL,
  p_street text DEFAULT NULL,
  p_floor text DEFAULT NULL,
  p_department text DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_clinic public.clinic_data%ROWTYPE;
  v_address public.clinic_address%ROWTYPE;
BEGIN
  -- 1. Insert into clinic_data with is_booking defaulting to false
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

  -- 2. Insert into clinic_address if any address field is provided
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

  RETURN jsonb_build_object(
    'clinic', to_jsonb(v_clinic),
    'address', to_jsonb(v_address)
  );
END;
$$;

-- Grant execution permissions
GRANT EXECUTE ON FUNCTION public.add_clinic_for_doctor(uuid, text, text, integer, boolean, boolean, bigint, bigint, bigint, bigint, text, text, text) TO authenticated, service_role, anon;

-- Reload schema cache
NOTIFY pgrst, 'reload schema';
