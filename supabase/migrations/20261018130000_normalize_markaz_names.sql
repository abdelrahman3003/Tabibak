-- Keep markaz display names free of the redundant Arabic "مركز" prefix.
-- IDs and all relationships remain unchanged.

UPDATE public.markaz
SET name_ar = NULLIF(
  regexp_replace(trim(name_ar), '^مركز[[:space:]]+', ''),
  ''
)
WHERE name_ar ~ '^مركز[[:space:]]+';

CREATE OR REPLACE FUNCTION public.normalize_markaz_name()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  IF NEW.name_ar IS NOT NULL THEN
    NEW.name_ar := NULLIF(
      regexp_replace(trim(NEW.name_ar), '^مركز[[:space:]]+', ''),
      ''
    );
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS markaz_normalize_name ON public.markaz;
CREATE TRIGGER markaz_normalize_name
BEFORE INSERT OR UPDATE OF name_ar ON public.markaz
FOR EACH ROW
EXECUTE FUNCTION public.normalize_markaz_name();

NOTIFY pgrst, 'reload schema';
