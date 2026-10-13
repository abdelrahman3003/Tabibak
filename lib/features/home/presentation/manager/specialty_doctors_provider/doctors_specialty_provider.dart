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

  static final List<CityModel> defaultMarkazes = [
    CityModel(id: 10, nameAr: 'مركز قنا', nameEn: 'Qena', type: 'markaz'),
    CityModel(id: 9, nameAr: 'مركز دشنا', nameEn: 'Dishna', type: 'markaz'),
    CityModel(
        id: 7, nameAr: 'مركز نجع حمادي', nameEn: 'Nag Hammadi', type: 'markaz'),
    CityModel(id: 12, nameAr: 'مركز قوص', nameEn: 'Qus', type: 'markaz'),
    CityModel(
        id: 5, nameAr: 'مركز أبو تشت', nameEn: 'Abu Tesht', type: 'markaz'),
    CityModel(id: 6, nameAr: 'مركز فرشوط', nameEn: 'Farshut', type: 'markaz'),
    CityModel(id: 8, nameAr: 'مركز الوقف', nameEn: 'Al Waqf', type: 'markaz'),
    CityModel(id: 11, nameAr: 'مركز قفط', nameEn: 'Qift', type: 'markaz'),
    CityModel(id: 13, nameAr: 'مركز نقادة', nameEn: 'Naqada', type: 'markaz'),
  ];

  Future<void> loadLocations() async {
    if (state.governorates.isEmpty) {
      state = state.copyWith(governorates: defaultGovernorates);
    }
    if (state.markazes.isEmpty) {
      state = state.copyWith(markazes: defaultMarkazes);
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
          sortBy: sortBy,
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

        state = state.copyWith(
          isLoading: false,
          specialtyDoctors: specialtyDoctors,
          allSpecialtyDoctors: !hasAnyLocFilter
              ? specialtyDoctors
              : (state.allSpecialtyDoctors ?? specialtyDoctors),
          selectedGovernorateId: governorateId,
          selectedMarkazId: markazId,
          selectedVillageId: villageId,
          clearAllLocations: !hasAnyLocFilter,
          isHighestRated: sortBy == 'avg_rating',
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

    if (state.isHighestRated) {
      filtered.sort((a, b) {
        final aRating = a.avrRating ?? 0;
        final bRating = b.avrRating ?? 0;
        return bRating.compareTo(aRating);
      });
    }

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
        if (state.isHighestRated) {
          filtered
              .sort((a, b) => (b.avrRating ?? 0).compareTo(a.avrRating ?? 0));
        }
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
