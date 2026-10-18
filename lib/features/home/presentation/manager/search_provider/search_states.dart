import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';

class SearchStates {
  final bool isLoading;
  final bool? isDeleteLoading;
  List<DoctorModel>? searchDoctorsList;
  String? errorMessage;
  final List<SpecialtyModel> specialties;
  final List<CityModel> governorates;
  final List<CityModel> markazes;
  final int? specialtyId, governorateId, markazId;

  SearchStates({
    this.isLoading = false,
    this.searchDoctorsList,
    this.errorMessage,
    this.isDeleteLoading,
    this.specialties = const [],
    this.governorates = const [],
    this.markazes = const [],
    this.specialtyId,
    this.governorateId,
    this.markazId,
  });
  SearchStates copyWith({
    bool? isLoading,
    String? errorMessage,
    List<DoctorModel>? searchDoctorsList,
    bool? isDeleteLoading,
    List<SpecialtyModel>? specialties,
    List<CityModel>? governorates,
    List<CityModel>? markazes,
    int? specialtyId,
    int? governorateId,
    int? markazId,
    bool clearSpecialty = false,
    bool clearGovernorate = false,
    bool clearMarkaz = false,
  }) {
    return SearchStates(
      isLoading: isLoading ?? false,
      searchDoctorsList: searchDoctorsList ?? this.searchDoctorsList,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeleteLoading: isDeleteLoading ?? this.isDeleteLoading,
      specialties: specialties ?? this.specialties,
      governorates: governorates ?? this.governorates,
      markazes: markazes ?? this.markazes,
      specialtyId: clearSpecialty ? null : (specialtyId ?? this.specialtyId),
      governorateId:
          clearGovernorate ? null : (governorateId ?? this.governorateId),
      markazId: clearMarkaz ? null : (markazId ?? this.markazId),
    );
  }
}
