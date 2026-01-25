import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';

class HomeStates {
  final bool isLoading;
  final bool? isSendCommentLoading;
  final UserModel? userModel;
  final List<DoctorModel>? topDoctorsList;
  final List<SpecialtyModel>? specialties;
  final String? errorMessage;

  HomeStates({
    this.isLoading = false,
    this.userModel,
    this.isSendCommentLoading,
    this.specialties,
    this.errorMessage,
    this.topDoctorsList,
  });

  HomeStates copyWith({
    bool? isLoading,
    bool? isSendCommentLoading,
    UserModel? userModel,
    List<DoctorModel>? topDoctorsList,
    List<DoctorModel>? doctorsSpecialtyList,
    List<SpecialtyModel>? specialties,
    List<DoctorModel>? doctorsModelList,
    String? errorMessage,
  }) {
    return HomeStates(
      isLoading: isLoading ?? false,
      isSendCommentLoading: isSendCommentLoading ?? this.isSendCommentLoading,
      userModel: userModel ?? this.userModel,
      topDoctorsList: topDoctorsList ?? this.topDoctorsList,
      specialties: specialties ?? this.specialties,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
