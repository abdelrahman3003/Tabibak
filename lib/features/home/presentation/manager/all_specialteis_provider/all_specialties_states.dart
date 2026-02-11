import 'package:tabibak/features/home/data/model/specialty_model.dart';

class AllSpecialtiesStates {
  final bool? isLoading;
  final List<SpecialtyModel>? specialties;
  final String? errorMessage;

  AllSpecialtiesStates({
    this.isLoading = false,
    this.specialties,
    this.errorMessage,
  });
  AllSpecialtiesStates copyWith({
    bool? isLoading,
    List<SpecialtyModel>? specialties,
    String? errorMessage,
  }) {
    return AllSpecialtiesStates(
      isLoading: isLoading,
      specialties: specialties ?? this.specialties,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
