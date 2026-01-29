import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/features/doctor/presentaion/manager/doctor/doctor_provider.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/repo/home_repo.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';
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
    searchTextController = TextEditingController();
    //  removeCachedList();
    cachedList = getSavedDoctors();
  }

  TextEditingController? searchTextController;
  List<DoctorModel>? cachedList;
  void search(String search) async {
    if (search.isEmpty) {
      state = SearchStates();
      return;
    }
    state = state.copyWith(isLoading: true);

    final result = await ref.read(homeRepoProvider).searchDoctor(search);
    result.when(
      sucess: (data) async {
        state = state.copyWith(searchDoctorsList: data);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.message);
      },
    );
  }

  Future<void> _saveDoctorSearch(String key, DoctorModel doctor) async {
    final alreadyExists = cachedList!.any((d) => d.doctorId == doctor.doctorId);
    if (!alreadyExists) {
      cachedList!.add(doctor);
    }
    final jsonList = jsonEncode(cachedList!.map((e) => e.toJson()).toList());

    await SharedPrefsService.prefs.setString(key, jsonList);
  }

  List<DoctorModel> getSavedDoctors() {
    final jsonString =
        SharedPrefsService.prefs.getString(SharedPrefKeys.searchDoctors);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);

    return decoded.map((e) => DoctorModel.fromJson(e)).toList();
  }

  void goToDoctorDetails(int index) async {
    final doctorList = state.searchDoctorsList ?? cachedList;
    await _saveDoctorSearch(SharedPrefKeys.searchDoctors, doctorList![index]);
    ref.read(doctorIdProvider.notifier).state = doctorList[index].doctorId;
  }

  removeCachedList() {
    SharedPrefsService.prefs.remove(SharedPrefKeys.searchDoctors);
  }

  removeDoctorFromCache(int doctorId) async {
    state = SearchStates(isDeleteLoading: true);
    cachedList!.removeWhere((doctor) => doctor.doctorId == doctorId);
    state = SearchStates(isDeleteLoading: false);
    final jsonList = jsonEncode(cachedList!.map((e) => e.toJson()).toList());
    await SharedPrefsService.prefs
        .setString(SharedPrefKeys.searchDoctors, jsonList);
  }

  @override
  void dispose() {
    super.dispose();
    searchTextController!.dispose();
  }
}
