import 'package:tabibak/features/home/data/model/doctor_model.dart';

class SpecialtyDoctorsStates {
  final bool isLoading;
  final String? errorMessage;
  final List<DoctorModel>? specialtyDoctors;
  SpecialtyDoctorsStates({
    this.isLoading = false,
    this.errorMessage,
    this.specialtyDoctors,
  });
  SpecialtyDoctorsStates copyWith({
    bool? isLoading,
    String? errorMessage,
    List<DoctorModel>? specialtyDoctors,
  }) {
    return SpecialtyDoctorsStates(
        isLoading: isLoading ?? false,
        errorMessage: errorMessage ?? this.errorMessage,
        specialtyDoctors: specialtyDoctors ?? this.specialtyDoctors);
  }
}
