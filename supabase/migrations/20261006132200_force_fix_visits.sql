-- 1. Drop any existing triggers that might be duplicating
DO $$
DECLARE
    trigger_record RECORD;
BEGIN
    FOR trigger_record IN 
        SELECT tgname 
        FROM pg_trigger 
        WHERE tgrelid = 'public.appointments'::regclass 
        AND tgname LIKE '%visits%'
    LOOP
        EXECUTE 'DROP TRIGGER IF EXISTS ' || trigger_record.tgname || ' ON public.appointments';
    END LOOP;
END $$;

-- 2. Create EXACTLY ONE trigger
CREATE TRIGGER trigger_update_doctor_visits_count
AFTER INSERT OR UPDATE OF status OR DELETE
ON public.appointments
FOR EACH ROW
EXECUTE FUNCTION public.update_doctor_visits_count();

-- 3. Force recount for all doctors
UPDATE public.doctors d
SET visits_count = (
    SELECT count(*)
    FROM public.appointments a
    WHERE a.doctor_id::text = d.doctor_id::text AND a.status = 3
);
