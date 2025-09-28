import 'package:tabibak/features/home/data/model/doctor_summary.dart';

class SearchStates {
  final bool isLoading;
  final bool? isDeleteLoading;
  List<DoctorSummary>? searchDoctorsList;
  String? errorMessage;

  SearchStates({
    this.isLoading = false,
    this.searchDoctorsList,
    this.errorMessage,
    this.isDeleteLoading,
  });
  SearchStates copyWith(
      {bool? isLoadin,
      String? errorMessage,
      List<DoctorSummary>? searchDoctorsList,
      bool? isDeleteLoading}) {
    return SearchStates(
        isLoading: isLoading,
        searchDoctorsList: searchDoctorsList ?? this.searchDoctorsList,
        errorMessage: errorMessage ?? this.errorMessage,
        isDeleteLoading: isDeleteLoading);
  }
}
