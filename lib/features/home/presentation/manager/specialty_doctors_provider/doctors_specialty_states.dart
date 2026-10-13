import 'package:tabibak/features/home/data/model/clinic_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class SpecialtyDoctorsStates {
  final bool isLoading;
  final String? errorMessage;
  final List<DoctorModel>? specialtyDoctors;
  final List<DoctorModel>? allSpecialtyDoctors;
  final List<CityModel> governorates;
  final List<CityModel> markazes;
  final List<CityModel> villages;
  final int? selectedGovernorateId;
  final int? selectedMarkazId;
  final int? selectedVillageId;
  final bool isHighestRated;

  SpecialtyDoctorsStates({
    this.isLoading = false,
    this.errorMessage,
    this.specialtyDoctors,
    this.allSpecialtyDoctors,
    this.governorates = const [],
    this.markazes = const [],
    this.villages = const [],
    this.selectedGovernorateId,
    this.selectedMarkazId,
    this.selectedVillageId,
    this.isHighestRated = false,
  });

  bool get hasLocationFilter =>
      selectedGovernorateId != null ||
      selectedMarkazId != null ||
      selectedVillageId != null;

  CityModel? get selectedGovernorate =>
      governorates.where((g) => g.id == selectedGovernorateId).firstOrNull;

  CityModel? get selectedMarkaz =>
      markazes.where((m) => m.id == selectedMarkazId).firstOrNull;

  CityModel? get selectedVillage =>
      villages.where((v) => v.id == selectedVillageId).firstOrNull;

  String? getActiveLocationLabel([String? locale]) {
    final lang = locale ?? 'ar';
    if (selectedVillage != null) {
      if (selectedMarkaz != null) {
        return '${selectedMarkaz!.getName(lang)} - ${selectedVillage!.getName(lang)}';
      }
      return selectedVillage!.getName(lang);
    }
    if (selectedMarkaz != null) {
      return selectedMarkaz!.getName(lang);
    }
    if (selectedGovernorate != null) {
      return selectedGovernorate!.getName(lang);
    }
    return null;
  }

  String? get activeLocationLabel => getActiveLocationLabel('ar');

  SpecialtyDoctorsStates copyWith({
    bool? isLoading,
    String? errorMessage,
    List<DoctorModel>? specialtyDoctors,
    List<DoctorModel>? allSpecialtyDoctors,
    List<CityModel>? governorates,
    List<CityModel>? markazes,
    List<CityModel>? villages,
    int? selectedGovernorateId,
    int? selectedMarkazId,
    int? selectedVillageId,
    bool clearSelectedGovernorate = false,
    bool clearSelectedMarkaz = false,
    bool clearSelectedVillage = false,
    bool clearAllLocations = false,
    bool? isHighestRated,
  }) {
    return SpecialtyDoctorsStates(
      isLoading: isLoading ?? false,
      errorMessage: errorMessage ?? this.errorMessage,
      specialtyDoctors: specialtyDoctors ?? this.specialtyDoctors,
      allSpecialtyDoctors: allSpecialtyDoctors ?? this.allSpecialtyDoctors,
      governorates: governorates ?? this.governorates,
      markazes: markazes ?? this.markazes,
      villages: villages ?? this.villages,
      selectedGovernorateId: clearAllLocations || clearSelectedGovernorate
          ? null
          : (selectedGovernorateId ?? this.selectedGovernorateId),
      selectedMarkazId: clearAllLocations || clearSelectedMarkaz
          ? null
          : (selectedMarkazId ?? this.selectedMarkazId),
      selectedVillageId: clearAllLocations || clearSelectedVillage
          ? null
          : (selectedVillageId ?? this.selectedVillageId),
      isHighestRated: isHighestRated ?? this.isHighestRated,
    );
  }
}
