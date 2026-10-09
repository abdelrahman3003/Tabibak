import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

void main() async {
  await dotenv.load(fileName: ".env");
  final supabase = SupabaseClient(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final res = await supabase.from('offers').select('*');
  print('Offers in DB: $res');
  exit(0);
}
