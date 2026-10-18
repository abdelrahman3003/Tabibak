-- doctors.markaz_id was removed when location data was normalized.
-- Clinic addresses are now the canonical source for doctor locations.
CREATE OR REPLACE FUNCTION public.get_filtered_sorted_doctor_ids(
    spec_id integer,
    sort_by text DEFAULT NULL,
    ascending boolean DEFAULT false,
    p_markaz_id integer DEFAULT NULL
)
RETURNS TABLE(doctor_id uuid)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $function$
BEGIN
    RETURN QUERY
    SELECT d.doctor_id
    FROM public.doctors d
    LEFT JOIN public.clinic_data c ON c.doctor_id = d.doctor_id
    LEFT JOIN public.clinic_address ca ON ca.clinic_id = c.id
    WHERE d.status = 2
      AND (spec_id IS NULL OR d.specialty = spec_id)
      AND (p_markaz_id IS NULL OR ca.markaz_id = p_markaz_id)
    GROUP BY d.doctor_id, d.name, d.avg_rating
    ORDER BY
        CASE WHEN (sort_by = 'avg_rating' OR sort_by IS NULL) AND NOT ascending THEN
            CASE WHEN d.avg_rating IS NOT NULL AND d.avg_rating > 0 THEN 1 ELSE 0 END
        END DESC,
        CASE WHEN (sort_by = 'avg_rating' OR sort_by IS NULL) AND NOT ascending THEN d.avg_rating END DESC NULLS LAST,
        CASE WHEN sort_by = 'avg_rating' AND ascending THEN d.avg_rating END ASC,
        d.name;
END;
$function$;

GRANT EXECUTE ON FUNCTION public.get_filtered_sorted_doctor_ids(integer, text, boolean, integer)
    TO authenticated, service_role, anon;

NOTIFY pgrst, 'reload schema';
