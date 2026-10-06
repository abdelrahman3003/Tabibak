SELECT trigger_name, event_manipulation 
FROM information_schema.triggers 
WHERE event_object_table = 'appointments';
