-- Keep user addresses normalized without rewriting or deleting existing rows.
-- The three IDs remain nullable so partial addresses are still supported.
ALTER TABLE public.user_addresses
  ADD COLUMN IF NOT EXISTS governorate_id bigint,
  ADD COLUMN IF NOT EXISTS markaz_id bigint,
  ADD COLUMN IF NOT EXISTS village_id bigint;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'user_addresses_governorate_id_fkey'
      AND conrelid = 'public.user_addresses'::regclass
  ) THEN
    ALTER TABLE public.user_addresses
      ADD CONSTRAINT user_addresses_governorate_id_fkey
      FOREIGN KEY (governorate_id) REFERENCES public.governorates(id)
      ON DELETE RESTRICT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'user_addresses_markaz_id_fkey'
      AND conrelid = 'public.user_addresses'::regclass
  ) THEN
    ALTER TABLE public.user_addresses
      ADD CONSTRAINT user_addresses_markaz_id_fkey
      FOREIGN KEY (markaz_id) REFERENCES public.markaz(id)
      ON DELETE RESTRICT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'user_addresses_village_id_fkey'
      AND conrelid = 'public.user_addresses'::regclass
  ) THEN
    ALTER TABLE public.user_addresses
      ADD CONSTRAINT user_addresses_village_id_fkey
      FOREIGN KEY (village_id) REFERENCES public.villages(id)
      ON DELETE RESTRICT;
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS user_addresses_governorate_idx
  ON public.user_addresses(governorate_id);
CREATE INDEX IF NOT EXISTS user_addresses_markaz_idx
  ON public.user_addresses(markaz_id);
CREATE INDEX IF NOT EXISTS user_addresses_village_idx
  ON public.user_addresses(village_id);

-- Enforce the hierarchy for new and updated addresses. Existing rows are not
-- rewritten, so applying this migration is non-destructive.
CREATE OR REPLACE FUNCTION public.validate_user_address_hierarchy()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  IF NEW.markaz_id IS NOT NULL AND NEW.governorate_id IS NOT NULL
     AND NOT EXISTS (
       SELECT 1 FROM public.markaz
       WHERE id = NEW.markaz_id AND governorate_id = NEW.governorate_id
     ) THEN
    RAISE EXCEPTION 'markaz_id % does not belong to governorate_id %',
      NEW.markaz_id, NEW.governorate_id;
  END IF;

  IF NEW.village_id IS NOT NULL AND NEW.markaz_id IS NOT NULL
     AND NOT EXISTS (
       SELECT 1 FROM public.villages
       WHERE id = NEW.village_id AND markaz_id = NEW.markaz_id
     ) THEN
    RAISE EXCEPTION 'village_id % does not belong to markaz_id %',
      NEW.village_id, NEW.markaz_id;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS user_addresses_validate_hierarchy
  ON public.user_addresses;
CREATE TRIGGER user_addresses_validate_hierarchy
  BEFORE INSERT OR UPDATE OF governorate_id, markaz_id, village_id
  ON public.user_addresses
  FOR EACH ROW EXECUTE FUNCTION public.validate_user_address_hierarchy();

NOTIFY pgrst, 'reload schema';
