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
    final response = await supabase
        .from('users')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (response != null) {
      return UserModel.fromJson(response);
    }

    // A newly authenticated user may not have a users row yet.
    return UserModel(
      userId: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] as String? ?? '',
      image: user.userMetadata?['avatar_url'] as String?,
    );
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
    // Location filtering is applied by DoctorsSpecialtyProvider using the
    // normalized clinic_address data. Fetch the approved specialty doctors
    // directly so this screen does not depend on a stale location RPC.
    var query = supabase
        .from('doctors')
        .select(ApiConstants.getDoctors)
        .eq('status', 2);
    if (specialtyId != null) {
      query = query.eq('specialty', specialtyId);
    }
    final doctors = await query;

    return (doctors as List).map((e) => DoctorModel.fromJson(e)).toList();
  }

  Future<List<CityModel>> getGovernorates({int? specialtyId}) async {
    final response = specialtyId == null
        ? await supabase.rpc('get_governorates_with_doctors')
        : await supabase.rpc('get_specialty_governorates_with_doctors',
            params: {'p_specialty_id': specialtyId});

    return (response as List)
        .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CityModel>> getMarkazes({int? governorateId, int? specialtyId}) async {
    final response = specialtyId == null
        ? await supabase.rpc('get_markazes_with_doctors', params: {
            'p_governorate_id': governorateId,
          })
        : await supabase.rpc('get_specialty_markazes_with_doctors', params: {
            'p_specialty_id': specialtyId,
            'p_governorate_id': governorateId,
          });

    return (response as List)
        .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CityModel>> getVillages({int? markazId, int? specialtyId}) async {
    final response = specialtyId == null
        ? await supabase.rpc('get_villages_with_doctors',
            params: {'p_markaz_id': markazId})
        : await supabase.rpc('get_specialty_villages_with_doctors', params: {
            'p_specialty_id': specialtyId,
            'p_markaz_id': markazId,
          });
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
