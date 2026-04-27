import 'package:tabibak/features/pharamcy/data/models/pharamcy_employee_model.dart';
import 'package:tabibak/features/pharamcy/data/models/pharmacy_model.dart';
import 'package:tabibak/features/pharamcy/data/models/pharmacy_offer_model.dart';

class PharmacyDetailsState {
  final bool isLoading;
  final String? errorMessage;
  final PharmacyModel? pharmacy;
  final List<PharmacyEmployeeModel> employees;
  final List<PharmacyOfferModel> offers;

  const PharmacyDetailsState({
    this.isLoading = false,
    this.errorMessage,
    this.pharmacy,
    this.employees = const [],
    this.offers = const [],
  });

  PharmacyDetailsState copyWith({
    bool? isLoading,
    String? errorMessage,
    PharmacyModel? pharmacy,
    List<PharmacyEmployeeModel>? employees,
    List<PharmacyOfferModel>? offers,
  }) {
    return PharmacyDetailsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      pharmacy: pharmacy ?? this.pharmacy,
      employees: employees ?? this.employees,
      offers: offers ?? this.offers,
    );
  }
}
