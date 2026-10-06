-- Create a trigger function that calls the Edge Function using pg_net
CREATE OR REPLACE FUNCTION public.trigger_doctor_approved_notification()
RETURNS TRIGGER AS $$
DECLARE
    -- The URL will be for local development. For production, you should update this 
    -- or create a Database Webhook from the Supabase Dashboard.
    webhook_url text := 'http://host.docker.internal:54321/functions/v1/doctor-approved-notification';
BEGIN
    -- Check if the doctor's status was changed to 2 (approved)
    IF NEW.status = 2 AND OLD.status IS DISTINCT FROM 2 THEN
        PERFORM net.http_post(
            url := webhook_url,
            headers := '{"Content-Type": "application/json"}'::jsonb,
            body := jsonb_build_object(
                'type', 'UPDATE',
                'table', 'doctors',
                'record', row_to_json(NEW),
                'old_record', row_to_json(OLD)
            )
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Attach the trigger to the doctors table
DROP TRIGGER IF EXISTS on_doctor_approved ON public.doctors;
CREATE TRIGGER on_doctor_approved
AFTER UPDATE ON public.doctors
FOR EACH ROW
EXECUTE FUNCTION public.trigger_doctor_approved_notification();
