-- Returns only markazes (districts) that have at least one active doctor (status = 2).
-- A doctor is linked to a markaz via either:
--   1. clinic_address.markaz_id (through clinic_data), or
--   2. doctors.markaz_id (direct column on the doctors table).

CREATE OR REPLACE FUNCTION public.get_markazes_with_doctors()
RETURNS TABLE(id bigint, name_ar text, name_en text, type text, parent_id bigint)
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $function$
BEGIN
    RETURN QUERY
    SELECT DISTINCT c.id, c.name_ar, c.name_en, c.type, c.parent_id
    FROM public.city c
    WHERE c.type = 'markaz'
      AND (
          -- Path 1: markaz referenced via clinic_address
          EXISTS (
              SELECT 1
              FROM public.clinic_address ca
              JOIN public.clinic_data cd ON cd.id = ca.clinic_id
              JOIN public.doctors d ON d.doctor_id = cd.doctor_id
              WHERE ca.markaz_id = c.id
                AND d.status = 2
          )
          OR
          -- Path 2: markaz referenced directly on the doctor row
          EXISTS (
              SELECT 1
              FROM public.doctors d
              WHERE d.markaz_id = c.id
                AND d.status = 2
          )
      )
    ORDER BY c.id;
END;
$function$;

GRANT EXECUTE ON FUNCTION public.get_markazes_with_doctors() TO authenticated, service_role, anon;

-- Returns only villages that have at least one active doctor (status = 2).
CREATE OR REPLACE FUNCTION public.get_villages_with_doctors(p_markaz_id integer DEFAULT NULL)
RETURNS TABLE(id bigint, name_ar text, name_en text, type text, parent_id bigint)
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $function$
BEGIN
    RETURN QUERY
    SELECT DISTINCT c.id, c.name_ar, c.name_en, c.type, c.parent_id
    FROM public.city c
    WHERE (p_markaz_id IS NULL OR c.parent_id = p_markaz_id)
      AND EXISTS (
          SELECT 1
          FROM public.clinic_address ca
          JOIN public.clinic_data cd ON cd.id = ca.clinic_id
          JOIN public.doctors d ON d.doctor_id = cd.doctor_id
          WHERE ca.village_id = c.id
            AND d.status = 2
      )
    ORDER BY c.name_ar;
END;
$function$;

GRANT EXECUTE ON FUNCTION public.get_villages_with_doctors(integer) TO authenticated, service_role, anon;

