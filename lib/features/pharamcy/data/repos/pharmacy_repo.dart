import 'dart:developer';

import 'package:tabibak/features/pharamcy/data/models/pharamcy_employee_model.dart';
import 'package:tabibak/features/pharamcy/data/remote_data_source/pharamcy_remote_data_source.dart';

import '../models/pharmacy_model.dart';
import '../models/pharmacy_offer_model.dart';

class PharmacyRepository {
  final PharmacyRemoteDataSource _dataSource;

  PharmacyRepository(this._dataSource);

  // ==================== Pharmacies ====================
  Future<List<PharmacyModel>> getPharmacies() async {
    try {
      return await _dataSource.getPharmacies();
    } catch (e) {
      throw Exception('Repository Error - getPharmacies: $e');
    }
  }

  Future<PharmacyModel> getPharmacyById(int id) async {
    try {
      return await _dataSource.getPharmacyById(id);
    } catch (e) {
      log("-------- pahr.  $e");
      throw Exception('Repository Error - getPharmacyById: $e');
    }
  }

  // ==================== Employees ====================
  Future<List<PharmacyEmployeeModel>> getEmployees(int pharmacyId) async {
    try {
      return await _dataSource.getEmployeesByPharmacyId(pharmacyId);
    } catch (e) {
      log("-------- emp.  $e");

      throw Exception('Repository Error - getEmployees: $e');
    }
  }

  // ==================== Offers ====================
  Future<List<PharmacyOfferModel>> getOffers(int pharmacyId) async {
    try {
      return await _dataSource.getOffersByPharmacyId(pharmacyId);
    } catch (e) {
      log("-------- off.  $e");

      throw Exception('Repository Error - getOffers: $e');
    }
  }
}
