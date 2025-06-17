import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/my_app.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['API_KEY'];
  final baseUrl = dotenv.env['BASE_URL'];
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: baseUrl!,
    anonKey: apiKey!,
  );
  runApp(ProviderScope(child: const MyApp()));
}
