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
    final list =
        response.map((doctor) => DoctorModel.fromJson(doctor)).toList();
    list.sort(DoctorModel.compareByRating);
    return list;
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

    final list = (doctors as List).map((e) => DoctorModel.fromJson(e)).toList();
    list.sort(DoctorModel.compareByRating);
    return list;
  }

  Future<List<CityModel>> getGovernorates() async {
    try {
      final response = await supabase
          .from('governorate')
          .select('id, name_ar, name_en')
          .order('id');
      final list = (response as List)
          .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
          .toList();
      if (list.isNotEmpty) return list;
    } catch (_) {}
    return [
      CityModel(id: 1, nameAr: 'قنا', nameEn: 'Qena', type: 'governorate'),
    ];
  }

  Future<List<CityModel>> getMarkazes() async {
    // Get distinct markaz IDs that have at least one active doctor
    final doctorRows = await supabase
        .from('doctors')
        .select('markaz_id, clinic_data(clinic_address(markaz_id))')
        .eq('status', 2);

    final activeIds = <int>{};
    for (final row in doctorRows as List) {
      final id = row['markaz_id'];
      if (id != null) activeIds.add(id is int ? id : (id as num).toInt());

      final clinicData = row['clinic_data'];
      if (clinicData is List) {
        for (final cd in clinicData) {
          if (cd is Map) {
            final clinicAddress = cd['clinic_address'];
            if (clinicAddress is List) {
              for (final ca in clinicAddress) {
                if (ca is Map) {
                  final caMarkazId = ca['markaz_id'];
                  if (caMarkazId != null) {
                    activeIds.add(caMarkazId is int
                        ? caMarkazId
                        : (caMarkazId as num).toInt());
                  }
                }
              }
            } else if (clinicAddress is Map) {
              final caMarkazId = clinicAddress['markaz_id'];
              if (caMarkazId != null) {
                activeIds.add(caMarkazId is int
                    ? caMarkazId
                    : (caMarkazId as num).toInt());
              }
            }
          }
        }
      } else if (clinicData is Map) {
        final clinicAddress = clinicData['clinic_address'];
        if (clinicAddress is List) {
          for (final ca in clinicAddress) {
            if (ca is Map) {
              final caMarkazId = ca['markaz_id'];
              if (caMarkazId != null) {
                activeIds.add(caMarkazId is int
                    ? caMarkazId
                    : (caMarkazId as num).toInt());
              }
            }
          }
        } else if (clinicAddress is Map) {
          final caMarkazId = clinicAddress['markaz_id'];
          if (caMarkazId != null) {
            activeIds.add(caMarkazId is int
                ? caMarkazId
                : (caMarkazId as num).toInt());
          }
        }
      }
    }

    if (activeIds.isEmpty) return [];

    // Fetch only markazes that have doctors
    final response = await supabase
        .from('city')
        .select('id, name_ar, name_en, type, parent_id')
        .eq('type', 'markaz')
        .inFilter('id', activeIds.toList())
        .order('id');

    return (response as List)
        .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CityModel>> getVillages({int? markazId}) async {
    // Get distinct village IDs belonging to active doctors (status = 2)
    final doctorRows = await supabase
        .from('doctors')
        .select('clinic_data(clinic_address(markaz_id, village_id))')
        .eq('status', 2);

    final activeVillageIds = <int>{};
    for (final row in doctorRows as List) {
      final clinicData = row['clinic_data'];
      if (clinicData is List) {
        for (final cd in clinicData) {
          if (cd is Map) {
            final clinicAddress = cd['clinic_address'];
            if (clinicAddress is List) {
              for (final ca in clinicAddress) {
                if (ca is Map) {
                  final vId = ca['village_id'];
                  if (vId != null) {
                    activeVillageIds.add(vId is int ? vId : (vId as num).toInt());
                  }
                }
              }
            } else if (clinicAddress is Map) {
              final vId = clinicAddress['village_id'];
              if (vId != null) {
                activeVillageIds.add(vId is int ? vId : (vId as num).toInt());
              }
            }
          }
        }
      } else if (clinicData is Map) {
        final clinicAddress = clinicData['clinic_address'];
        if (clinicAddress is List) {
          for (final ca in clinicAddress) {
            if (ca is Map) {
              final vId = ca['village_id'];
              if (vId != null) {
                activeVillageIds.add(vId is int ? vId : (vId as num).toInt());
              }
            }
          }
        } else if (clinicAddress is Map) {
          final vId = clinicAddress['village_id'];
          if (vId != null) {
            activeVillageIds.add(vId is int ? vId : (vId as num).toInt());
          }
        }
      }
    }

    if (activeVillageIds.isEmpty) return [];

    var query = supabase
        .from('city')
        .select('id, name_ar, name_en, type, parent_id')
        .inFilter('id', activeVillageIds.toList());

    if (markazId != null) {
      query = query.eq('parent_id', markazId);
    }

    final response = await query.order('name_ar');
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

    final list = (response as List).map((e) => DoctorModel.fromJson(e)).toList();
    list.sort(DoctorModel.compareByRating);
    return list;
  }

  Future<List<PharmacyOfferModel>> getAllOffers() async {
    final response = await supabase
        .from('pharmacy_offer')
        .select('*,pharmacies(*)')
        .eq('is_active', true);

    return (response as List)
        .map((e) => PharmacyOfferModel.fromJson(e))
        .where((e) => e.isValid)
        .toList();
  }
}
