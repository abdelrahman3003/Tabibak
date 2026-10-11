-- RPC function to completely remove a clinic and its associated records
CREATE OR REPLACE FUNCTION public.remove_clinic(
  p_clinic_id bigint,
  p_doctor_id uuid DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_clinic public.clinic_data%ROWTYPE;
  v_morning_shift_ids integer[];
  v_evening_shift_ids integer[];
BEGIN
  -- 1. Check clinic existence and ownership (if p_doctor_id is provided)
  IF p_doctor_id IS NOT NULL THEN
    SELECT * INTO v_clinic 
    FROM public.clinic_data 
    WHERE id = p_clinic_id AND doctor_id = p_doctor_id;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Clinic not found or you do not have permission to delete it.';
    END IF;
  ELSE
    SELECT * INTO v_clinic 
    FROM public.clinic_data 
    WHERE id = p_clinic_id;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Clinic with ID % not found.', p_clinic_id;
    END IF;
  END IF;

  -- 2. Collect shift IDs associated with this clinic's working days to avoid orphans
  SELECT 
    COALESCE(array_agg(shift_morning_id) FILTER (WHERE shift_morning_id IS NOT NULL), '{}'),
    COALESCE(array_agg(shift_evening_id) FILTER (WHERE shift_evening_id IS NOT NULL), '{}')
  INTO v_morning_shift_ids, v_evening_shift_ids
  FROM public.working_day
  WHERE clinic_id = p_clinic_id;

  -- 3. Delete working_day records for this clinic
  DELETE FROM public.working_day WHERE clinic_id = p_clinic_id;

  -- 4. Clean up orphan shifts from shifts_morning and shift_evening
  IF array_length(v_morning_shift_ids, 1) > 0 THEN
    DELETE FROM public.shifts_morning WHERE id = ANY(v_morning_shift_ids);
  END IF;

  IF array_length(v_evening_shift_ids, 1) > 0 THEN
    DELETE FROM public.shift_evening WHERE id = ANY(v_evening_shift_ids);
  END IF;

  -- 5. Delete clinic address
  DELETE FROM public.clinic_address WHERE clinic_id = p_clinic_id;

  -- 6. Delete offers for this clinic (if offers table exists)
  DELETE FROM public.offers WHERE clinic_id = p_clinic_id;

  -- 7. Delete the clinic from clinic_data
  DELETE FROM public.clinic_data WHERE id = p_clinic_id;

  RETURN jsonb_build_object(
    'success', true,
    'message', 'Clinic deleted successfully',
    'deleted_clinic_id', p_clinic_id
  );
END;
$$;

-- Grant execution permissions
GRANT EXECUTE ON FUNCTION public.remove_clinic(bigint, uuid) TO authenticated, service_role, anon;

-- Reload schema cache
NOTIFY pgrst, 'reload schema';
