import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/get_specialite_response.dart';

class HomeRemoteData {
  final SupabaseClient supabase = Supabase.instance.client;
  Future<UserModel> fetchUserById() async {
    final response = await supabase
        .from('users')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .single();

    return UserModel.fromJson(response);
  }

  Future<GetSpecialiteResponse> fetchSpecialties() async {
    final response = await supabase.from('specialties').select();
    return GetSpecialiteResponse.fromJson({'data': response});
  }
}
