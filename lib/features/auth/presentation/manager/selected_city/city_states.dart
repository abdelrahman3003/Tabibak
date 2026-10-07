import 'package:tabibak/features/home/data/model/clinic_model.dart';

class CityStates {
  final List<CityModel> cities;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final int? selectedCityId;
  final int? selectedDistrictId;
  final int? selectedVillageId;
  final bool isSaved;

  const CityStates({
    this.cities = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.selectedCityId,
    this.selectedDistrictId,
    this.selectedVillageId,
    this.isSaved = false,
  });

  CityStates copyWith({
    List<CityModel>? cities,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    int? selectedCityId,
    int? selectedDistrictId,
    int? selectedVillageId,
    bool? isSaved,
  }) {
    return CityStates(
      cities: cities ?? this.cities,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      selectedCityId: selectedCityId ?? this.selectedCityId,
      selectedDistrictId: selectedDistrictId ?? this.selectedDistrictId,
      selectedVillageId: selectedVillageId ?? this.selectedVillageId,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  CityStates clearSelections(
      {bool clearDistrict = false,
      bool clearCity = false,
      bool clearVillage = false}) {
    return CityStates(
      cities: cities,
      isLoading: isLoading,
      isSaving: isSaving,
      errorMessage: errorMessage,
      isSaved: isSaved,
      selectedDistrictId: clearDistrict ? null : selectedDistrictId,
      selectedCityId: clearCity ? null : selectedCityId,
      selectedVillageId: clearVillage ? null : selectedVillageId,
    );
  }
}
