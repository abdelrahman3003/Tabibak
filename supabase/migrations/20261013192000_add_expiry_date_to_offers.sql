-- Add expiry_date column to offers table
ALTER TABLE public.offers ADD COLUMN IF NOT EXISTS expiry_date timestamptz;

-- If end_date exists on existing offers, backfill expiry_date with end_date
UPDATE public.offers
SET expiry_date = end_date
WHERE expiry_date IS NULL AND end_date IS NOT NULL;

-- Update add_clinic_offer RPC to support p_expiry_date
CREATE OR REPLACE FUNCTION public.add_clinic_offer(
  p_clinic_id bigint,
  p_title_en text,
  p_title_ar text,
  p_details_en text,
  p_details_ar text,
  p_discount numeric,
  p_start_date timestamptz DEFAULT NULL,
  p_end_date timestamptz DEFAULT NULL,
  p_expiry_date timestamptz DEFAULT NULL
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
    expiry_date,
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
    COALESCE(p_expiry_date, p_end_date),
    true
  ) RETURNING * INTO new_offer;
  
  RETURN new_offer;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Also add expiry_date to pharmacy_offer table if it exists
DO $$
BEGIN
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'pharmacy_offer') THEN
    ALTER TABLE public.pharmacy_offer ADD COLUMN IF NOT EXISTS expiry_date timestamptz;
    UPDATE public.pharmacy_offer SET expiry_date = end_date WHERE expiry_date IS NULL AND end_date IS NOT NULL;
  END IF;
END $$;
