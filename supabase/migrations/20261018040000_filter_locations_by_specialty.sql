-- Specialty-aware location options for the doctors filter UI.
CREATE OR REPLACE FUNCTION public.get_specialty_governorates_with_doctors(
  p_specialty_id integer
)
RETURNS SETOF public.governorates
LANGUAGE sql STABLE
SET search_path = public
AS $$
  SELECT g.* FROM public.governorates g
  WHERE EXISTS (
    SELECT 1 FROM public.doctors d
    JOIN public.clinic_data c ON c.doctor_id = d.doctor_id
    JOIN public.clinic_address ca ON ca.clinic_id = c.id
    LEFT JOIN public.villages v ON v.id = ca.village_id
    LEFT JOIN public.markaz cm ON cm.id = COALESCE(ca.markaz_id, v.markaz_id)
    WHERE d.status = 2 AND d.specialty = p_specialty_id
      AND COALESCE(ca.governorate_id, cm.governorate_id) = g.id
  )
  ORDER BY g.name_ar;
$$;

CREATE OR REPLACE FUNCTION public.get_specialty_markazes_with_doctors(
  p_specialty_id integer,
  p_governorate_id bigint DEFAULT NULL
)
RETURNS SETOF public.markaz
LANGUAGE sql STABLE
SET search_path = public
AS $$
  SELECT m.* FROM public.markaz m
  WHERE (p_governorate_id IS NULL OR m.governorate_id = p_governorate_id)
    AND EXISTS (
      SELECT 1 FROM public.doctors d
      JOIN public.clinic_data c ON c.doctor_id = d.doctor_id
      JOIN public.clinic_address ca ON ca.clinic_id = c.id
      LEFT JOIN public.villages v ON v.id = ca.village_id
      WHERE d.status = 2 AND d.specialty = p_specialty_id
        AND COALESCE(ca.markaz_id, v.markaz_id) = m.id
    )
  ORDER BY m.name_ar;
$$;

CREATE OR REPLACE FUNCTION public.get_specialty_villages_with_doctors(
  p_specialty_id integer,
  p_markaz_id bigint DEFAULT NULL
)
RETURNS SETOF public.villages
LANGUAGE sql STABLE
SET search_path = public
AS $$
  SELECT v.* FROM public.villages v
  WHERE (p_markaz_id IS NULL OR v.markaz_id = p_markaz_id)
    AND EXISTS (
      SELECT 1 FROM public.doctors d
      JOIN public.clinic_data c ON c.doctor_id = d.doctor_id
      JOIN public.clinic_address ca ON ca.clinic_id = c.id
      WHERE d.status = 2 AND d.specialty = p_specialty_id
        AND ca.village_id = v.id
    )
  ORDER BY v.name_ar;
$$;

GRANT EXECUTE ON FUNCTION public.get_specialty_governorates_with_doctors(integer) TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.get_specialty_markazes_with_doctors(integer, bigint) TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.get_specialty_villages_with_doctors(integer, bigint) TO anon, authenticated, service_role;

NOTIFY pgrst, 'reload schema';
