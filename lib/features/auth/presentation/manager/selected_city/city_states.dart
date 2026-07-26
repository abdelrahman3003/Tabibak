import 'package:tabibak/features/home/data/model/clinic_model.dart';

class CityStates {
  final List<CityModel> cities;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final int? selectedCityId;
  final bool isSaved;

  const CityStates({
    this.cities = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.selectedCityId,
    this.isSaved = false,
  });

  CityStates copyWith({
    List<CityModel>? cities,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    int? selectedCityId,
    bool? isSaved,
  }) {
    return CityStates(
      cities: cities ?? this.cities,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      selectedCityId: selectedCityId ?? this.selectedCityId,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
