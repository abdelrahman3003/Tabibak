import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/repo/home_repo.dart';
import 'package:tabibak/features/home/presentation/manager/search_provider/search_states.dart';

final searchProviderNotifier =
    StateNotifierProvider.autoDispose<SearchProvider, SearchStates>(
        (ref) => SearchProvider(ref, getIt<HomeRepo>()));

class SearchProvider extends StateNotifier<SearchStates> {
  final HomeRepo homeRepo;
  final Ref ref;

  SearchProvider(this.ref, this.homeRepo) : super(SearchStates()) {
    initData();
  }

  void initData() async {
    cachedList = _getSavedDoctors();
    state = state.copyWith(searchDoctorsList: cachedList);
  }

  List<DoctorModel> cachedList = [];

  void search(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchDoctorsList: cachedList);
      return;
    }
    state = state.copyWith(isLoading: true);
    final result = await homeRepo.searchDoctor(query);
    result.when(
      sucess: (searchedDoctors) {
        state = state.copyWith(searchDoctorsList: searchedDoctors);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.message);
      },
    );
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
