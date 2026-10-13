import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/doctors_specialty_states.dart';

final specialtyProvider = StateProvider<SpecialtyModel?>((ref) => null);
final doctorsSpecialtyProvider =
    StateNotifierProvider<DoctorsSpecialtyProvider, SpecialtyDoctorsStates>(
  (ref) => DoctorsSpecialtyProvider(ref),
);

class DoctorsSpecialtyProvider extends StateNotifier<SpecialtyDoctorsStates> {
  DoctorsSpecialtyProvider(this.ref) : super(SpecialtyDoctorsStates()) {
    loadLocations();
  }
  final Ref ref;

  static final List<CityModel> defaultGovernorates = [
    CityModel(id: 1, nameAr: 'قنا', nameEn: 'Qena', type: 'governorate'),
  ];

  static final List<CityModel> defaultMarkazes = <CityModel>[];

  static int compareDoctorsByRating(DoctorModel a, DoctorModel b) =>
      DoctorModel.compareByRating(a, b);

  Future<void> loadLocations() async {
    if (state.governorates.isEmpty) {
      state = state.copyWith(governorates: defaultGovernorates);
    }

    final repo = ref.read(homeRepoProvider);

    // Load governorates
    final govResult = await repo.getGovernorates();
    if (!mounted) return;
    govResult.when(
      sucess: (govs) {
        if (govs.isNotEmpty && mounted) {
          state = state.copyWith(governorates: govs);
        }
      },
      failure: (_) {},
    );

    // Load markazes
    final markazResult = await repo.getMarkazes();
    if (!mounted) return;
    markazResult.when(
      sucess: (markazes) {
        if (markazes.isNotEmpty && mounted) {
          state = state.copyWith(markazes: markazes);
        }
      },
      failure: (_) {},
    );

    // Load all villages
    final villageResult = await repo.getVillages();
    if (!mounted) return;
    villageResult.when(
      sucess: (villages) {
        if (villages.isNotEmpty && mounted) {
          state = state.copyWith(villages: villages);
        }
      },
      failure: (_) {},
    );
  }

  Future<void> loadMarkazes() async {
    await loadLocations();
  }

  Future<void> getSpecialtiesDoctors({
    int? specialtyId,
    String? sortBy,
    int? markazId,
    int? governorateId,
    int? villageId,
  }) async {
    state = state.copyWith(isLoading: true);
    if (state.markazes.isEmpty || state.governorates.isEmpty) {
      loadLocations();
    }
    final targetSpecialtyId = specialtyId ?? ref.read(specialtyProvider)?.id;
    final result = await ref.read(homeRepoProvider).getDoctorSpecialist(
          sortBy: sortBy ?? 'avg_rating',
          specialtyId: targetSpecialtyId,
          markazId: markazId,
        );

    if (!mounted) return;

    result.when(
      sucess: (specialtyDoctors) {
        if (!mounted) return;
        final bool hasAnyLocFilter = markazId != null ||
            governorateId != null ||
            villageId != null;

        final sorted = List<DoctorModel>.from(specialtyDoctors)
          ..sort(DoctorModel.compareByRating);

        state = state.copyWith(
          isLoading: false,
          specialtyDoctors: sorted,
          allSpecialtyDoctors: !hasAnyLocFilter
              ? sorted
              : (state.allSpecialtyDoctors ?? sorted),
          selectedGovernorateId: governorateId,
          selectedMarkazId: markazId,
          selectedVillageId: villageId,
          clearAllLocations: !hasAnyLocFilter,
          isHighestRated: true,
        );

        if (hasAnyLocFilter) {
          _applyFilters();
        }
      },
      failure: (apiErrorModel) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: apiErrorModel.errors,
        );
      },
    );
  }

  bool _doctorMatchesLocation(
    DoctorModel doctor, {
    int? governorateId,
    int? markazId,
    int? villageId,
  }) {
    if (governorateId == null && markazId == null && villageId == null) {
      return true;
    }

    final clinics = doctor.clinicList ??
        (doctor.clinic != null ? [doctor.clinic!] : <ClinicModel>[]);

    for (final clinic in clinics) {
      if (clinic.clinicAddresses != null) {
        for (final addr in clinic.clinicAddresses!) {
          bool govMatch = true;
          if (governorateId != null) {
            govMatch = addr.governorateId == governorateId ||
                addr.governorate?.id == governorateId ||
                governorateId == 1; // Default Qena
          }

          bool markazMatch = true;
          if (markazId != null) {
            markazMatch = addr.markazId == markazId ||
                addr.markaz?.id == markazId ||
                doctor.markazId == markazId;
          }

          bool villageMatch = true;
          if (villageId != null) {
            villageMatch = addr.villageId == villageId ||
                addr.village?.id == villageId;
          }

          if (govMatch && markazMatch && villageMatch) {
            return true;
          }
        }
      }
    }

    // Direct doctor markaz fallback when no clinic address matched village specifically
    if (villageId == null && markazId != null && doctor.markazId == markazId) {
      return true;
    }

    // Only governorate selected and default Qena matches
    if (villageId == null && markazId == null && governorateId == 1) {
      return true;
    }

    return false;
  }

  void filterByLocation({
    int? governorateId,
    int? markazId,
    int? villageId,
  }) {
    if (state.allSpecialtyDoctors == null) {
      getSpecialtiesDoctors(
        governorateId: governorateId,
        markazId: markazId,
        villageId: villageId,
      );
      return;
    }

    state = state.copyWith(
      selectedGovernorateId: governorateId,
      selectedMarkazId: markazId,
      selectedVillageId: villageId,
      clearSelectedGovernorate: governorateId == null,
      clearSelectedMarkaz: markazId == null,
      clearSelectedVillage: villageId == null,
    );
    _applyFilters();
  }

  void filterByMarkaz(int? markazId) {
    filterByLocation(
      governorateId: state.selectedGovernorateId,
      markazId: markazId,
      villageId: null, // Reset village if markaz changes
    );
  }

  void clearMarkazFilter() {
    filterByLocation(
      governorateId: state.selectedGovernorateId,
      markazId: null,
      villageId: null,
    );
  }

  void clearLocationFilter() {
    state = state.copyWith(clearAllLocations: true);
    _applyFilters();
  }

  void setHighestRated(bool isHighestRated) {
    state = state.copyWith(isHighestRated: isHighestRated);
    _applyFilters();
  }

  void toggleSortByRating() {
    state = state.copyWith(isHighestRated: !state.isHighestRated);
    _applyFilters();
  }

  void sortDoctorsByRating({bool ascending = false}) {
    state = state.copyWith(isHighestRated: true);
    _applyFilters();
  }

  void applyAllFilters({
    int? governorateId,
    int? markazId,
    int? villageId,
    bool? isHighestRated,
  }) {
    state = state.copyWith(
      selectedGovernorateId: governorateId,
      selectedMarkazId: markazId,
      selectedVillageId: villageId,
      clearSelectedGovernorate: governorateId == null,
      clearSelectedMarkaz: markazId == null,
      clearSelectedVillage: villageId == null,
      isHighestRated: isHighestRated ?? state.isHighestRated,
    );
    _applyFilters();
  }

  void clearAllFilters() {
    state = state.copyWith(
      clearAllLocations: true,
      isHighestRated: false,
    );
    _applyFilters();
  }

  void _applyFilters() {
    final baseList = state.allSpecialtyDoctors ?? [];
    var filtered = List<DoctorModel>.from(baseList);

    if (state.hasLocationFilter) {
      filtered = filtered
          .where((d) => _doctorMatchesLocation(
                d,
                governorateId: state.selectedGovernorateId,
                markazId: state.selectedMarkazId,
                villageId: state.selectedVillageId,
              ))
          .toList();
    }

    // Always sort by rating descending, with unrated doctors last
    filtered.sort(DoctorModel.compareByRating);

    state = state.copyWith(
      specialtyDoctors: filtered,
      isLoading: false,
    );
  }

  Future<void> searchDoctorSpecialty(String search, {int? specialtyId}) async {
    if (search.trim().isEmpty) {
      _applyFilters();
      return;
    }
    state = state.copyWith(isLoading: true);
    final targetSpecialtyId = specialtyId ?? ref.read(specialtyProvider)?.id;
    final result = await ref.read(homeRepoProvider).searchDoctor(
          search,
          specialtyId: targetSpecialtyId,
        );
    result.when(
      sucess: (doctors) {
        var filtered = List<DoctorModel>.from(doctors);
        if (state.hasLocationFilter) {
          filtered = filtered
              .where((d) => _doctorMatchesLocation(
                    d,
                    governorateId: state.selectedGovernorateId,
                    markazId: state.selectedMarkazId,
                    villageId: state.selectedVillageId,
                  ))
              .toList();
        }
        filtered.sort(DoctorModel.compareByRating);
        state = state.copyWith(
          isLoading: false,
          specialtyDoctors: filtered,
        );
      },
      failure: (apiErrorModel) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: apiErrorModel.errors,
        );
      },
    );
  }
}
