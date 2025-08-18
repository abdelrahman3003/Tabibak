import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/core/networking/api_service.dart';
import 'package:tabibak/core/services/dio_factory.dart';

class ProfileRemoteDataSource {
  final SupabaseClient supabase = Supabase.instance.client;
  final ApiService apiService = ApiService(DioFactory.getDio());

  Future<void> signOut() async {
    return await supabase.auth.signOut();
  }

  Future<String> uploadProfileImage(XFile file) async {
    final fileBytes = await file.readAsBytes();
    final fileName = "profile_${supabase.auth.currentUser!.id}.png";

    await supabase.storage.from("profile_images").uploadBinary(
        fileName, fileBytes,
        fileOptions: const FileOptions(upsert: true));

    final imageUrl =
        supabase.storage.from("profile_images").getPublicUrl(fileName);
    final freshUrl = "$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}";
    return freshUrl;
  }

  Future<ApiResult<void>> updateProfileImage(String imageUrl) async {
    await supabase.from("users").update({"image": imageUrl}).eq(
        "user_id", supabase.auth.currentUser!.id);
    return ApiResult.sucess(null);
  }
}
