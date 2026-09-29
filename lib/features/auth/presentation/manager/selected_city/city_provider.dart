import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/auth/data/repo/auth_repo.dart';
import 'package:tabibak/features/auth/presentation/manager/selected_city/city_states.dart';

final cityProvider = StateNotifierProvider<CityNotifier, CityStates>(
  (ref) => CityNotifier(CityStates(), getIt<AuthRepository>()),
);

class CityNotifier extends StateNotifier<CityStates> {
  CityNotifier(
    super.state,
    this.authRepo,
  );

  final AuthRepository authRepo;

  Future<void> getCities() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    final result = await authRepo.getCities();

    result.when(
      sucess: (cities) {
        state = state.copyWith(
          isLoading: false,
          cities: cities,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.message,
        );
      },
    );
  }

  void updateCity(int? cityId) {
    state = state.clearSelections(clearVillage: true).copyWith(
      selectedCityId: cityId,
    );
  }

  void updateDistrict(int? districtId) {
    state = state.clearSelections(clearCity: true, clearVillage: true).copyWith(
      selectedDistrictId: districtId,
    );
  }

  void updateVillage(int? villageId) {
    state = state.clearSelections(clearCity: true).copyWith(
      selectedVillageId: villageId,
    );
  }

  Future<void> saveCity() async {
    if (state.selectedCityId == null && state.selectedDistrictId == null && state.selectedVillageId == null) return;

    state = state.copyWith(
      isSaving: true,
      errorMessage: null,
      isSaved: false,
    );

    // If cityId is somehow null (e.g., they only selected district/village), provide 0 or similar if backend allows, or just whatever they selected.
    // The requirement says "update address of user according supabase for cities and district and village". 
    // Usually cityId is required by backend, but we can just send what we have.
    final result = await authRepo.updateUserCity(
      cityId: state.selectedCityId,
      districtId: state.selectedDistrictId,
      villageId: state.selectedVillageId,
    );

    result.when(
      sucess: (_) {
        state = state.copyWith(
          isSaving: false,
          isSaved: true,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: error.message,
          isSaved: false,
        );
      },
    );
  }
}

