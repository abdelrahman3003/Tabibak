import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_consatnt.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';

class HomeRemoteData {
  final SupabaseClient supabase;

  HomeRemoteData({required this.supabase});
  Future<UserModel> getUserData() async {
    final response = await supabase
        .from('users')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .single();

    return UserModel.fromJson(response);
  }

  Future<List<SpecialtyModel>> getSpecialties() async {
    final response = await supabase.from('specialties').select();
    return response.map((e) => SpecialtyModel.fromJson(e)).toList();
  }

  Future<List<DoctorModel>> getTopDoctors() async {
    final response = await supabase
        .from('doctors')
        .select(ApiConstants.getDoctors)
        .eq("status", 3)
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
  }) async {
    final response = await supabase.rpc(
      'get_filtered_sorted_doctor_ids',
      params: {
        'spec_id': specialtyId,
        'sort_by': sortBy,
        'ascending': false,
      },
    );

    final doctorIds = (response as List).map((e) => e['doctor_id']).toList();

    if (doctorIds.isEmpty) return [];

    final doctors = await supabase
        .from('doctors')
        .select(ApiConstants.getDoctors)
        .inFilter('doctor_id', doctorIds);

    return (doctors as List).map((e) => DoctorModel.fromJson(e)).toList();
  }

  Future<List<DoctorModel>> searchDoctor(String search,
      {int? specialtyId}) async {
    var query = supabase.from('doctors').select('*, specialty(*)');

    if (specialtyId != null) {
      query = query.eq('specialty', specialtyId);
    }

    if (search.isNotEmpty) {
      query = query.ilike('name', '%$search%');
    }

    final response = await query;

    return (response as List).map((e) => DoctorModel.fromJson(e)).toList();
  }
}
