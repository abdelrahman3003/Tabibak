CREATE OR REPLACE FUNCTION public.add_clinic_offer(
  p_clinic_id bigint,
  p_title_en text,
  p_title_ar text,
  p_details_en text,
  p_details_ar text,
  p_discount numeric,
  p_start_date timestamptz DEFAULT NULL,
  p_end_date timestamptz DEFAULT NULL
) RETURNS public.offers AS $$
DECLARE
  v_doctor_id uuid;
  new_offer public.offers;
BEGIN
  -- Auto-fetch the doctor_id from clinic_data based on the provided clinic_id
  SELECT doctor_id::uuid INTO v_doctor_id FROM public.clinic_data WHERE id = p_clinic_id;

  IF v_doctor_id IS NULL THEN
    RAISE EXCEPTION 'Clinic not found or doctor_id missing for clinic_id: %', p_clinic_id;
  END IF;

  INSERT INTO public.offers (
    clinic_id,
    doctor_id,
    title_en,
    title_ar,
    details_en,
    details_ar,
    discount,
    start_date,
    end_date,
    is_active
  ) VALUES (
    p_clinic_id,
    v_doctor_id,
    p_title_en,
    p_title_ar,
    p_details_en,
    p_details_ar,
    p_discount,
    p_start_date,
    p_end_date,
    true
  ) RETURNING * INTO new_offer;
  
  RETURN new_offer;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop the old function that required p_doctor_id
DROP FUNCTION IF EXISTS public.add_clinic_offer(bigint, uuid, text, text, text, text, numeric, timestamptz, timestamptz);
