import 'dart:io';
import 'package:supabase/supabase.dart';

void main() async {
  final supabase = SupabaseClient(
    'https://wzfdmzijnyaihssxwril.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6ZmRtemlqbnlhaWhzc3h3cmlsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAwNzY1MDQsImV4cCI6MjA2NTY1MjUwNH0.LtLpGqD0fX2gBFrrIJRAB_KcuoScYwXUayNJrQZEBNw'
  );

  try {
    final response = await supabase
        .from('doctors')
        .select("doctor_id, name, offers(*)")
        .limit(5);
    
    print('Response: $response');
  } catch (e) {
    print('Error: $e');
  }
  exit(0);
}
