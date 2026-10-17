import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_consatnt.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';
import 'package:tabibak/features/pharamcy/data/models/pharmacy_offer_model.dart';

class HomeRemoteData {
  final SupabaseClient supabase;

  HomeRemoteData({required this.supabase});
  Future<UserModel> getUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('User not logged in');
    }
    final response =
        await supabase.from('users').select().eq('user_id', user.id).single();

    return UserModel.fromJson(response);
  }

  Future<List<SpecialtyModel>> getSpecialties() async {
    final response = await supabase.from('specialties').select('''
        id,
        name_ar,
        name_en,
        icon,
        doctors!inner(id,status)
      ''').eq('doctors.status', 2);

    return response.map((e) {
      e.remove('doctors');
      return SpecialtyModel.fromJson(e);
    }).toList();
  }

  Future<List<DoctorModel>> getTopDoctors() async {
    final response = await supabase
        .from('doctors')
        .select(ApiConstants.getDoctors)
        .eq("status", 2)
        .order('avg_rating', ascending: false)
        .limit(5);
    return response.map((doctor) => DoctorModel.fromJson(doctor)).toList();
  }

  Future<DoctorModel> getDoctorById(String doctorId) async {
    final response = await supabase
        .from('doctors')
        .select(ApiConstants.getDoctors)
        .eq('doctor_id', doctorId)
        .single();

    return DoctorModel.fromJson(response);
  }

  Future<List<DoctorModel>> getSpecialtyDoctors({
    int? specialtyId,
    String? sortBy,
    bool ascending = false,
    int? markazId,
  }) async {
    final response = await supabase.rpc(
      'get_filtered_sorted_doctor_ids',
      params: {
        'spec_id': specialtyId,
        'sort_by': sortBy ?? 'avg_rating',
        'ascending': ascending,
        'p_markaz_id': markazId,
      },
    );

    final doctorIds = (response as List).map((e) => e['doctor_id']).toList();

    if (doctorIds.isEmpty) return [];

    final doctors = await supabase
        .from('doctors')
        .select(ApiConstants.getDoctors)
        .eq('status', 2)
        .inFilter('doctor_id', doctorIds);

    return (doctors as List).map((e) => DoctorModel.fromJson(e)).toList();
  }

  Future<List<CityModel>> getGovernorates() async {
    final response = await supabase
        .from('governorate')
        .select('id, name_ar, name_en, type, parent_id')
        .order('id');

    return (response as List)
        .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CityModel>> getMarkazes() async {
    final response = await supabase.rpc('get_markazes_with_doctors');

    return (response as List)
        .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CityModel>> getVillages({int? markazId}) async {
    final response = await supabase.rpc(
      'get_villages_with_doctors',
      params: {'p_markaz_id': markazId},
    );
    return (response as List)
        .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<DoctorModel>> searchDoctor(String search,
      {int? specialtyId}) async {
    var query = supabase
        .from('doctors')
        .select(ApiConstants.getDoctors)
        .eq('status', 2);
    if (specialtyId != null) {
      query = query.eq('specialty', specialtyId);
    }
    if (search.isNotEmpty) {
      query = query.ilike('name', '%$search%');
    }
    final response = await query;

    return (response as List).map((e) => DoctorModel.fromJson(e)).toList();
  }

  Future<List<PharmacyOfferModel>> getAllOffers() async {
    final response = await supabase
        .from('pharmacy_offer')
        .select('*,pharmacies(*)')
        .eq('is_active', true);

    return (response as List)
        .map((e) => PharmacyOfferModel.fromJson(e))
        .toList();
  }
}
