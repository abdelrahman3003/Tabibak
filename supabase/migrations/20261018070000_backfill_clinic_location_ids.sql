UPDATE public.clinic_address ca
SET markaz_id = v.markaz_id
FROM public.villages v
WHERE ca.village_id = v.id AND ca.markaz_id IS NULL;

UPDATE public.clinic_address ca
SET governorate_id = m.governorate_id
FROM public.markaz m
WHERE ca.markaz_id = m.id AND ca.governorate_id IS NULL;

NOTIFY pgrst, 'reload schema';
