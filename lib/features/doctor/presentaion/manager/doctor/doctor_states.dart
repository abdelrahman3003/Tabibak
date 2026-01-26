import 'package:tabibak/features/home/data/model/comment_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class DoctorStates {
  final bool isLoading;

  final DoctorModel? doctorModel;
  final String? errorMessage;
  DoctorStates({
    this.doctorModel,
    this.errorMessage,
    this.isLoading = false,
  });
  DoctorStates copyWith({
    final List<CommentModel>? doctorCommentModelList,
    final DoctorModel? doctorModel,
    final String? errorMessage,
    final bool? isLoading,
  }) {
    return DoctorStates(
      isLoading: isLoading ?? false,
      doctorModel: doctorModel ?? this.doctorModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
