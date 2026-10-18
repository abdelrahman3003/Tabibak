CREATE OR REPLACE FUNCTION public.get_specialty_location_filters(p_specialty_id integer)
RETURNS jsonb LANGUAGE sql STABLE SET search_path = public AS $$
  SELECT COALESCE(jsonb_agg(jsonb_build_object(
    'id', g.id, 'name_ar', g.name_ar, 'name_en', g.name_en,
    'markazes', (
      SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'id', m.id, 'name_ar', m.name_ar, 'name_en', m.name_en,
        'governorate_id', m.governorate_id,
        'villages', (
          SELECT COALESCE(jsonb_agg(jsonb_build_object(
            'id', v.id, 'name_ar', v.name_ar, 'name_en', v.name_en,
            'markaz_id', v.markaz_id
          ) ORDER BY v.name_ar), '[]'::jsonb)
          FROM public.villages v
          WHERE v.markaz_id = m.id AND EXISTS (
            SELECT 1 FROM public.doctors d
            JOIN public.clinic_data c ON c.doctor_id = d.doctor_id
            JOIN public.clinic_address ca ON ca.clinic_id = c.id
            WHERE d.status = 2 AND d.specialty = p_specialty_id
              AND ca.village_id = v.id
          )
        )
      ) ORDER BY m.name_ar), '[]'::jsonb)
      FROM public.markaz m
      WHERE m.governorate_id = g.id AND EXISTS (
        SELECT 1 FROM public.doctors d
        JOIN public.clinic_data c ON c.doctor_id = d.doctor_id
        JOIN public.clinic_address ca ON ca.clinic_id = c.id
        LEFT JOIN public.villages v ON v.id = ca.village_id
        WHERE d.status = 2 AND d.specialty = p_specialty_id
          AND COALESCE(ca.markaz_id, v.markaz_id) = m.id
      )
    )
  ) ORDER BY g.name_ar), '[]'::jsonb)
  FROM public.governorates g
  WHERE EXISTS (
    SELECT 1 FROM public.doctors d
    JOIN public.clinic_data c ON c.doctor_id = d.doctor_id
    JOIN public.clinic_address ca ON ca.clinic_id = c.id
    LEFT JOIN public.villages v ON v.id = ca.village_id
    LEFT JOIN public.markaz m ON m.id = COALESCE(ca.markaz_id, v.markaz_id)
    WHERE d.status = 2 AND d.specialty = p_specialty_id
      AND COALESCE(ca.governorate_id, m.governorate_id) = g.id
  );
$$;

GRANT EXECUTE ON FUNCTION public.get_specialty_location_filters(integer)
  TO anon, authenticated, service_role;
NOTIFY pgrst, 'reload schema';
