import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/pharamcy_employee_model.dart';
import '../models/pharmacy_model.dart';
import '../models/pharmacy_offer_model.dart';

class PharmacyRemoteDataSource {
  final Supabase supabase;

  PharmacyRemoteDataSource({required this.supabase});

  // ==================== Pharmacy ====================
  Future<List<PharmacyModel>> getPharmacies() async {
    final response = await supabase.client.from('pharmacies').select();

    return (response as List).map((e) => PharmacyModel.fromJson(e)).toList();
  }

  Future<PharmacyModel> getPharmacyById(int id) async {
    final response =
        await supabase.client.from('pharmacies').select().eq('id', id).single();

    return PharmacyModel.fromJson(response);
  }

  Future<List<PharmacyEmployeeModel>> getEmployeesByPharmacyId(
      int pharmacyId) async {
    final response = await supabase.client
        .from('pharmacy_employee_rel')
        .select(
          'employee:pharmacy_employee!pharmacy_employee_rel_employee_id_fkey(*)',
        )
        .eq('pharmacy_id', pharmacyId);

    return (response as List)
        .map((e) => PharmacyEmployeeModel.fromJson(e['employee']))
        .toList();
  }

  // ==================== Offers ====================
  Future<List<PharmacyOfferModel>> getOffersByPharmacyId(int pharmacyId) async {
    final response = await supabase.client
        .from('pharmacy_offer')
        .select("*,pharmacies(*)")
        .eq('pharmacy_id', pharmacyId);

    return (response as List)
        .map((e) => PharmacyOfferModel.fromJson(e))
        .toList();
  }
}
