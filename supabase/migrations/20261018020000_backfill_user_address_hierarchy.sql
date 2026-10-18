-- Complete legacy address rows from their canonical parent relationships.
-- This only fills missing IDs and does not replace existing selections.
UPDATE public.user_addresses ua
SET markaz_id = v.markaz_id
FROM public.villages v
WHERE ua.village_id = v.id
  AND ua.markaz_id IS NULL;

UPDATE public.user_addresses ua
SET governorate_id = m.governorate_id
FROM public.markaz m
WHERE ua.markaz_id = m.id
  AND ua.governorate_id IS NULL;

NOTIFY pgrst, 'reload schema';
