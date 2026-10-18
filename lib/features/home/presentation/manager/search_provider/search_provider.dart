import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/repo/home_repo.dart';
import 'package:tabibak/features/home/data/repo/home_repo_imp.dart';
import 'package:tabibak/features/home/presentation/manager/search_provider/search_states.dart';

final searchProviderNotifier =
    StateNotifierProvider.autoDispose<SearchProvider, SearchStates>(
        (ref) => SearchProvider(ref, getIt<HomeRepo>()));

class SearchProvider extends StateNotifier<SearchStates> {
  final HomeRepo homeRepo;
  final Ref ref;

  SearchProvider(this.ref, this.homeRepo) : super(SearchStates()) {
    initData();
    loadFilterOptions();
  }

  void initData() async {
    cachedList = _getSavedDoctors();
    state = state.copyWith(searchDoctorsList: cachedList);
  }

  List<DoctorModel> cachedList = [];

  Future<void> search(String query) async {
    state = state.copyWith(isLoading: true);
    final result = homeRepo is HomeRepoImp
        ? await (homeRepo as HomeRepoImp).searchDoctorFiltered(query,
            specialtyId: state.specialtyId,
            governorateId: state.governorateId,
            markazId: state.markazId)
        : await homeRepo.searchDoctor(query, specialtyId: state.specialtyId);
    result.when(
      sucess: (searchedDoctors) {
        state = state.copyWith(
            searchDoctorsList: query.isEmpty &&
                    state.specialtyId == null &&
                    state.governorateId == null &&
                    state.markazId == null
                ? cachedList
                : searchedDoctors,
            isLoading: false);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.message);
      },
    );
  }

  Future<void> loadFilterOptions() async {
    final specialties = await homeRepo.getSpecialties();
    specialties.when(
        sucess: (v) => state = state.copyWith(specialties: v), failure: (_) {});
    final governorates = await homeRepo.getGovernorates();
    governorates.when(
        sucess: (v) => state = state.copyWith(governorates: v),
        failure: (_) {});
  }

  Future<void> loadMarkazes(int? governorateId) async {
    final result = await homeRepo.getMarkazes(governorateId: governorateId);
    result.when(
        sucess: (v) => state = state.copyWith(markazes: v), failure: (_) {});
  }

  Future<void> applyFilters(
      {int? specialtyId, int? governorateId, int? markazId}) async {
    state = state.copyWith(
        specialtyId: specialtyId,
        governorateId: governorateId,
        markazId: markazId,
        clearSpecialty: specialtyId == null,
        clearGovernorate: governorateId == null,
        clearMarkaz: markazId == null);
    await search('');
  }

  Future<void> saveDoctorSearch(DoctorModel doctor) async {
    final alreadyExists = cachedList.any((d) => d.doctorId == doctor.doctorId);
    if (!alreadyExists) {
      cachedList.insert(0, doctor);
      if (cachedList.length > 10) {
        cachedList.removeLast();
      }
    } else {
      // If it exists, move it to the top
      cachedList.removeWhere((d) => d.doctorId == doctor.doctorId);
      cachedList.insert(0, doctor);
    }

    final jsonList = jsonEncode(cachedList.map((e) => e.toJson()).toList());
    await SharedPrefsService.prefs
        .setString(SharedPrefKeys.searchDoctors, jsonList);
  }

  List<DoctorModel> _getSavedDoctors() {
    final jsonString =
        SharedPrefsService.prefs.getString(SharedPrefKeys.searchDoctors);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => DoctorModel.fromJson(e)).toList();
  }

  Future<void> removeCachedList() async {
    cachedList.clear();
    state = state.copyWith(searchDoctorsList: []);
    await SharedPrefsService.prefs.remove(SharedPrefKeys.searchDoctors);
  }

  Future<void> removeDoctorFromCache(String doctorId) async {
    cachedList.removeWhere((doctor) => doctor.doctorId == doctorId);
    state = state.copyWith(searchDoctorsList: List.from(cachedList));
    final jsonList = jsonEncode(cachedList.map((e) => e.toJson()).toList());
    await SharedPrefsService.prefs
        .setString(SharedPrefKeys.searchDoctors, jsonList);
  }
}
