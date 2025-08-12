import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDataSource {
  final SupabaseClient supabase = Supabase.instance.client;
  Future<void> signOut() async {
    return await supabase.auth.signOut();
  }
}
