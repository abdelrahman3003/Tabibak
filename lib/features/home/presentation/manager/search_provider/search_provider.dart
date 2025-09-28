import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/doctor_details/presentaion/manager/doctor_details_provider.dart';
import 'package:tabibak/features/home/data/model/doctor_summary.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';
import 'package:tabibak/features/home/presentation/manager/search_provider/search_states.dart';

final searchProviderNotifer =
    StateNotifierProvider.autoDispose<SearchProvider, SearchStates>(
        (ref) => SearchProvider(ref));

class SearchProvider extends StateNotifier<SearchStates> {
  SearchProvider(this.ref) : super(SearchStates()) {
    initData();
  }

  void initData() async {
    searchTextController = TextEditingController();
    //  removeCachedList();
    cachedList = getSavedDoctors();
  }

  final Ref ref;
  TextEditingController? searchTextController;
  List<DoctorSummary>? cachedList;
  void search(String search) async {
    if (search.isEmpty) {
      state = SearchStates();
      return;
    }
    state = SearchStates(isLoading: true);

    final result = await ref.read(homrepoProvider).searchDoctor(search);
    result.when(
      sucess: (data) async {
        state = SearchStates(searchDoctorsList: data);
      },
      failure: (apiErrorModel) {
        state = SearchStates(errorMessage: apiErrorModel.message);
      },
    );
  }

  Future<void> _saveDoctorSearch(String key, DoctorSummary doctor) async {
    final alreadyExists = cachedList!.any((d) => d.id == doctor.id);
    if (!alreadyExists) {
      cachedList!.add(doctor);
    }
    final jsonList = jsonEncode(cachedList!.map((e) => e.toJson()).toList());

    await SharedPrefsService.prefs.setString(key, jsonList);
  }

  List<DoctorSummary> getSavedDoctors() {
    final jsonString =
        SharedPrefsService.prefs.getString(SharedPrefKeys.searchDoctors);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);

    return decoded.map((e) => DoctorSummary.fromJson(e)).toList();
  }

  void goToDoctorDetails(BuildContext context, int index) async {
    final doctorList = state.searchDoctorsList ?? cachedList;
    int doctorId = doctorList![index].id;
    context.pushNamed(Routes.doctorDetailsScreen);
    await ref
        .watch(doctorDetailsNotifierProvider.notifier)
        .getDoctorById(doctorId);

    _saveDoctorSearch(SharedPrefKeys.searchDoctors, doctorList[index]);
  }

  removeCachedList() {
    SharedPrefsService.prefs.remove(SharedPrefKeys.searchDoctors);
  }

  removeDoctorFromCache(int doctorId) async {
    state = SearchStates(isDeleteLoading: true);
    cachedList!.removeWhere((doctor) => doctor.id == doctorId);
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
