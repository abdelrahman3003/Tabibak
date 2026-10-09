CREATE OR REPLACE FUNCTION public.add_clinic_offer(
  p_clinic_id bigint,
  p_doctor_id uuid,
  p_title_en text,
  p_title_ar text,
  p_details_en text,
  p_details_ar text,
  p_discount numeric,
  p_start_date timestamptz DEFAULT NULL,
  p_end_date timestamptz DEFAULT NULL
) RETURNS public.offers AS $$
DECLARE
  new_offer public.offers;
BEGIN
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
    p_doctor_id,
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
