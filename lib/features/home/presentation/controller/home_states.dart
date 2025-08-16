import 'package:tabibak/features/home/data/model/doctor_model.dart';

class HomeStates {}

class HomeIniail extends HomeStates {}

class HomeSpecialitesLoading extends HomeStates {}

class HomeSpecialitesSuccess extends HomeStates {}

class HomeSpecialitesFailure extends HomeStates {}

class HomeFechDataUserLoading extends HomeStates {}

class HomeFechDataUserSuccess extends HomeStates {}

class HomeFechDataUserFailure extends HomeStates {}

class HomeFechAllDoctorsLoading extends HomeStates {}

class HomeFechAllDoctorsSuccess extends HomeStates {}

class HomeFechAllDoctorsFailure extends HomeStates {}

class HomeGetAllDoctorsSummaryLoading extends HomeStates {}

class HomeGetAllDoctorsSummarySuccess extends HomeStates {}

class HomeGetAllDoctorsSummaryFailure extends HomeStates {}

class HomeGetDoctorLoading extends HomeStates {}

class HomeGetDoctorSuccess extends HomeStates {
  final DoctorModel doctorModel;

  HomeGetDoctorSuccess({required this.doctorModel});
}

class HomeGetDoctorFailure extends HomeStates {}

class HomeGetDoctorSpecialtyLoading extends HomeStates {}

class HomeGetDoctorSpecialtySuccess extends HomeStates {}

class HomeGetDoctorSpecialtyFailure extends HomeStates {}
