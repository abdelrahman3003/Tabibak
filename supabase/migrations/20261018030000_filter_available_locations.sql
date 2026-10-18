-- Return only locations that have at least one approved doctor with a clinic
-- address in that location. Names remain in the backend rows as name_ar/name_en.
CREATE OR REPLACE FUNCTION public.get_governorates_with_doctors()
RETURNS SETOF public.governorates
LANGUAGE sql STABLE
SET search_path = public
AS $$
  SELECT g.*
  FROM public.governorates g
  WHERE EXISTS (
    SELECT 1
    FROM public.doctors d
    JOIN public.clinic_data c ON c.doctor_id = d.doctor_id
    JOIN public.clinic_address ca ON ca.clinic_id = c.id
    WHERE d.status = 2 AND ca.governorate_id = g.id
  )
  ORDER BY g.name_ar;
$$;

CREATE OR REPLACE FUNCTION public.get_markazes_with_doctors(
  p_governorate_id bigint DEFAULT NULL
)
RETURNS SETOF public.markaz
LANGUAGE sql STABLE
SET search_path = public
AS $$
  SELECT m.*
  FROM public.markaz m
  WHERE (p_governorate_id IS NULL OR m.governorate_id = p_governorate_id)
    AND EXISTS (
      SELECT 1
      FROM public.doctors d
      JOIN public.clinic_data c ON c.doctor_id = d.doctor_id
      JOIN public.clinic_address ca ON ca.clinic_id = c.id
      WHERE d.status = 2 AND ca.markaz_id = m.id
    )
  ORDER BY m.name_ar;
$$;

CREATE OR REPLACE FUNCTION public.get_villages_with_doctors(
  p_markaz_id bigint DEFAULT NULL
)
RETURNS SETOF public.villages
LANGUAGE sql STABLE
SET search_path = public
AS $$
  SELECT v.*
  FROM public.villages v
  WHERE (p_markaz_id IS NULL OR v.markaz_id = p_markaz_id)
    AND EXISTS (
      SELECT 1
      FROM public.doctors d
      JOIN public.clinic_data c ON c.doctor_id = d.doctor_id
      JOIN public.clinic_address ca ON ca.clinic_id = c.id
      WHERE d.status = 2 AND ca.village_id = v.id
    )
  ORDER BY v.name_ar;
$$;

GRANT EXECUTE ON FUNCTION public.get_governorates_with_doctors() TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.get_markazes_with_doctors(bigint) TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.get_villages_with_doctors(bigint) TO anon, authenticated, service_role;

NOTIFY pgrst, 'reload schema';
