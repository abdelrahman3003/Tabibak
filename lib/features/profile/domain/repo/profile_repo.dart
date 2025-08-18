import 'package:image_picker/image_picker.dart';
import 'package:tabibak/core/networking/api_result.dart';

abstract class ProfileRepo {
  Future<ApiResult<void>> signOut();
  Future<ApiResult<String>> uploadProfileImage(XFile file);
  Future<ApiResult<void>> updateProfileImage(String imageUrl);
}
