import 'package:tabibak/features/home/data/model/doctor_model.dart';

class SearchStates {
  final bool isLoading;
  final bool? isDeleteLoading;
  List<DoctorModel>? searchDoctorsList;
  String? errorMessage;

  SearchStates({
    this.isLoading = false,
    this.searchDoctorsList,
    this.errorMessage,
    this.isDeleteLoading,
  });
  SearchStates copyWith(
      {bool? isLoading,
      String? errorMessage,
      List<DoctorModel>? searchDoctorsList,
      bool? isDeleteLoading}) {
    return SearchStates(
        isLoading: isLoading ?? false,
        searchDoctorsList: searchDoctorsList ?? this.searchDoctorsList,
        errorMessage: errorMessage ?? this.errorMessage,
        isDeleteLoading: isDeleteLoading);
  }
}
