-- 1. Add visits_count column if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_schema = 'public' 
                     AND table_name = 'doctors' 
                     AND column_name = 'visits_count') THEN
        ALTER TABLE public.doctors ADD COLUMN visits_count integer DEFAULT 0;
    END IF;
END $$;

-- 2. Update existing counts for all doctors
UPDATE public.doctors d
SET visits_count = (
    SELECT count(*)
    FROM public.appointments a
    WHERE a.doctor_id::text = d.id::text AND a.status = 3
);

-- 3. Create the trigger function
CREATE OR REPLACE FUNCTION public.update_doctor_visits_count()
RETURNS TRIGGER AS $$
BEGIN
    -- Handle INSERT
    IF (TG_OP = 'INSERT') THEN
        IF NEW.status = 3 THEN
            UPDATE public.doctors
            SET visits_count = COALESCE(visits_count, 0) + 1
            WHERE id::text = NEW.doctor_id::text;
        END IF;
        
    -- Handle UPDATE
    ELSIF (TG_OP = 'UPDATE') THEN
        -- If status changed TO 3
        IF NEW.status = 3 AND OLD.status IS DISTINCT FROM 3 THEN
            UPDATE public.doctors
            SET visits_count = COALESCE(visits_count, 0) + 1
            WHERE id::text = NEW.doctor_id::text;
        -- If status changed FROM 3 to something else
        ELSIF NEW.status IS DISTINCT FROM 3 AND OLD.status = 3 THEN
            UPDATE public.doctors
            SET visits_count = GREATEST(COALESCE(visits_count, 0) - 1, 0)
            WHERE id::text = OLD.doctor_id::text;
        END IF;
        
    -- Handle DELETE
    ELSIF (TG_OP = 'DELETE') THEN
        IF OLD.status = 3 THEN
            UPDATE public.doctors
            SET visits_count = GREATEST(COALESCE(visits_count, 0) - 1, 0)
            WHERE id::text = OLD.doctor_id::text;
        END IF;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. Create the trigger on the appointments table
DROP TRIGGER IF EXISTS trigger_update_doctor_visits_count ON public.appointments;

CREATE TRIGGER trigger_update_doctor_visits_count
AFTER INSERT OR UPDATE OF status OR DELETE
ON public.appointments
FOR EACH ROW
EXECUTE FUNCTION public.update_doctor_visits_count();
