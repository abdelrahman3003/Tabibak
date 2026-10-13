-- 1. Add markaz and markaz_id to doctors table
ALTER TABLE public.doctors ADD COLUMN IF NOT EXISTS markaz_id bigint REFERENCES public.city(id);
ALTER TABLE public.doctors ADD COLUMN IF NOT EXISTS markaz text;

-- 2. Add markaz text column to clinic_address table if not exists
ALTER TABLE public.clinic_address ADD COLUMN IF NOT EXISTS markaz text;

-- 3. Backfill markaz_id on doctors from clinic_address
UPDATE public.doctors d
SET markaz_id = ca.markaz_id
FROM public.clinic_data cd
JOIN public.clinic_address ca ON ca.clinic_id = cd.id
WHERE cd.doctor_id::text = d.doctor_id::text
  AND ca.markaz_id IS NOT NULL
  AND d.markaz_id IS NULL;

-- 4. Backfill markaz name on doctors and clinic_address from city
UPDATE public.doctors d
SET markaz = c.name_ar
FROM public.city c
WHERE d.markaz_id = c.id
  AND d.markaz IS NULL;

UPDATE public.clinic_address ca
SET markaz = c.name_ar
FROM public.city c
WHERE ca.markaz_id = c.id
  AND ca.markaz IS NULL;

-- 5. Drop old 3-arg function and create updated get_filtered_sorted_doctor_ids with p_markaz_id parameter
DROP FUNCTION IF EXISTS public.get_filtered_sorted_doctor_ids(integer, text, boolean);

CREATE OR REPLACE FUNCTION public.get_filtered_sorted_doctor_ids(
    spec_id integer,
    sort_by text DEFAULT NULL,
    ascending boolean DEFAULT false,
    p_markaz_id integer DEFAULT NULL
)
RETURNS TABLE(doctor_id uuid)
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT d.doctor_id
    FROM doctors d
    LEFT JOIN clinic_data c ON c.doctor_id = d.doctor_id
    LEFT JOIN clinic_address ca ON ca.clinic_id = c.id
    WHERE (spec_id IS NULL OR d.specialty = spec_id)
      AND (
          p_markaz_id IS NULL 
          OR ca.markaz_id = p_markaz_id 
          OR d.markaz_id = p_markaz_id
      )
    GROUP BY d.doctor_id, d.name, d.avg_rating
    ORDER BY
        CASE WHEN sort_by = 'consultation_fee' AND ascending THEN MIN(c.consultation_fee) END ASC,
        CASE WHEN sort_by = 'consultation_fee' AND NOT ascending THEN MIN(c.consultation_fee) END DESC,
        CASE WHEN sort_by = 'avg_rating' AND ascending THEN d.avg_rating END ASC,
        CASE WHEN sort_by = 'avg_rating' AND NOT ascending THEN d.avg_rating END DESC,
        d.name;
END;
$function$;

GRANT EXECUTE ON FUNCTION public.get_filtered_sorted_doctor_ids(integer, text, boolean, integer) TO authenticated, service_role, anon;
