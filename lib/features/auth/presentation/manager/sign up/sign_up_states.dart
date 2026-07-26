import 'package:tabibak/features/home/data/model/clinic_model.dart';

class SignUpStates {
  final bool isLoading;
  final String? errorMessage;
  final bool isSignedUp;
  final int? specialtyId;

  final List<CityModel> cities;
  final bool isCitiesLoading;
  final int? cityId;

  SignUpStates({
    this.isLoading = false,
    this.errorMessage,
    this.isSignedUp = false,
    this.specialtyId,
    this.cities = const [],
    this.isCitiesLoading = false,
    this.cityId,
  });

  SignUpStates copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSignedUp,
    int? specialtyId,
    List<CityModel>? cities,
    bool? isCitiesLoading,
    int? cityId,
  }) {
    return SignUpStates(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSignedUp: isSignedUp ?? this.isSignedUp,
      specialtyId: specialtyId ?? this.specialtyId,
      cities: cities ?? this.cities,
      isCitiesLoading: isCitiesLoading ?? this.isCitiesLoading,
      cityId: cityId ?? this.cityId,
    );
  }
}
