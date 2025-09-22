import 'package:tabibak/features/home/data/model/doctor_summary.dart';

class SearchStates {
  final bool isLoading;
  List<DoctorSummary>? searchDoctorsList;
  String? errorMessage;

  SearchStates(
      {this.isLoading = false, this.searchDoctorsList, this.errorMessage});
  SearchStates copyWith(
      {bool? isLoadin,
      String? errorMessage,
      List<DoctorSummary>? searchDoctorsList}) {
    return SearchStates(
        isLoading: isLoading,
        searchDoctorsList: searchDoctorsList ?? this.searchDoctorsList,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
