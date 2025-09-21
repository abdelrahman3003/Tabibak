import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/doctor_summary.dart';
import 'package:tabibak/features/home/data/model/specialise_model.dart';

class HomeStates {
  final bool isLoading;
  final bool? isSendCommentLoading;
  final UserModel? userModel;
  final List<DoctorSummary>? doctorsSummaryList;
  final List<DoctorModel>? doctorsModelList;
  final List<DoctorSummary>? doctorsSpecialityList;
  final List<SpecialiseModel>? specialties;
  final String? errorMessage;

  HomeStates({
    this.isLoading = false,
    this.userModel,
    this.isSendCommentLoading,
    this.doctorsSummaryList,
    this.doctorsSpecialityList,
    this.specialties,
    this.errorMessage,
    this.doctorsModelList,
  });

  HomeStates copyWith({
    bool? isLoading,
    bool? isSendCommentLoading,
    UserModel? userModel,
    List<DoctorSummary>? doctorsSummaryList,
    List<DoctorSummary>? doctorsSpecialityList,
    List<SpecialiseModel>? specialties,
    List<DoctorModel>? doctorsModelList,
    String? errorMessage,
  }) {
    return HomeStates(
      isLoading: isLoading ?? false,
      isSendCommentLoading: isSendCommentLoading ?? this.isSendCommentLoading,
      userModel: userModel ?? this.userModel,
      doctorsModelList: doctorsModelList ?? this.doctorsModelList,
      doctorsSummaryList: doctorsSummaryList ?? this.doctorsSummaryList,
      doctorsSpecialityList:
          doctorsSpecialityList ?? this.doctorsSpecialityList,
      specialties: specialties ?? this.specialties,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
