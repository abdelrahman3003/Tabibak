import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/pharamcy/data/repos/pharmacy_repo.dart';
import 'package:tabibak/features/pharamcy/presentation/manager/pharamcy_details_states.dart';

// ─── Repository Provider ────────────────────────────────────────────────────

final pharmacyRepositoryProvider = Provider<PharmacyRepository>(
  (ref) => getIt<PharmacyRepository>(),
);

class PharmacyDetailsController extends StateNotifier<PharmacyDetailsState> {
  PharmacyDetailsController(this.ref, this.pharmacyId)
      : super(const PharmacyDetailsState()) {
    initData();
  }

  final Ref ref;
  final int pharmacyId;

  PharmacyRepository get _repo => ref.read(pharmacyRepositoryProvider);

  void initData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.wait([
      getPharmacyById(),
      getEmployees(),
      getOffers(),
    ]);
    state = state.copyWith(isLoading: false);
  }

  Future<void> getPharmacyById() async {
    try {
      final pharmacy = await _repo.getPharmacyById(pharmacyId);
      state = state.copyWith(pharmacy: pharmacy);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> getEmployees() async {
    try {
      final employees = await _repo.getEmployees(pharmacyId);
      state = state.copyWith(employees: employees);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> getOffers() async {
    try {
      final offers = await _repo.getOffers(pharmacyId);
      state = state.copyWith(offers: offers);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void refresh() => initData();
}

// ─── Provider ───────────────────────────────────────────────────────────────

final pharmacyDetailsControllerProvider = StateNotifierProvider.autoDispose
    .family<PharmacyDetailsController, PharmacyDetailsState, int>(
  (ref, pharmacyId) => PharmacyDetailsController(ref, pharmacyId),
);
