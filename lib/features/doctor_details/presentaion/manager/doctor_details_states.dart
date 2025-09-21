import 'package:tabibak/features/home/data/model/doctor_model.dart';

class DoctorDetailsStates {
  final bool isLoading;

  final List<Comment>? doctorCommentModelList;
  final DoctorModel? doctorModel;
  final String? errorMessage;
  DoctorDetailsStates({
    this.doctorModel,
    this.doctorCommentModelList,
    this.errorMessage,
    this.isLoading = false,
  });
  DoctorDetailsStates copyWith({
    final List<Comment>? doctorCommentModelList,
    final DoctorModel? doctorModel,
    final String? errorMessage,
    final bool? isLoading,
  }) {
    return DoctorDetailsStates(
      doctorCommentModelList:
          doctorCommentModelList ?? this.doctorCommentModelList,
      doctorModel: doctorModel ?? this.doctorModel,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? false,
    );
  }
}
