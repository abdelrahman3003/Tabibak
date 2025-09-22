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
//    SharedPrefsService.prefs.remove(SharedPrefKeys.searchDoctors);
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

  Future<void> _saveDoctorSearch(String key, List<DoctorSummary> data) async {
    final jsonList = jsonEncode(data.map((e) => e.toJson()).toList());

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
    int doctorId = state.searchDoctorsList![index].id;
    cachedList!.add(state.searchDoctorsList![index]);
    context.pushNamed(Routes.doctorDetailsScreen);
    await ref
        .watch(doctorDetailsNotifierProvider.notifier)
        .getDoctorById(doctorId);
    _saveDoctorSearch(SharedPrefKeys.searchDoctors, cachedList!);
  }

  @override
  void dispose() {
    super.dispose();
    searchTextController!.dispose();
  }
}
