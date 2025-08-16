import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_consatnt.dart';
import 'package:tabibak/core/networking/api_service.dart';
import 'package:tabibak/core/services/dio_factory.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/doctor_comment_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/doctor_summary.dart';
import 'package:tabibak/features/home/data/model/specialise_model.dart';

class HomeRemoteData {
  final SupabaseClient supabase = Supabase.instance.client;
  final ApiService apiService = ApiService(DioFactory.getDio());
  Future<UserModel> fetchUserById() async {
    final response = await supabase
        .from('users')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .single();

    return UserModel.fromJson(response);
  }

  Future<List<SpecialiseModel>> fetchSpecialties() async {
    final response = await supabase.from('specialties').select();
    return response.map((e) => SpecialiseModel.fromJson(e)).toList();
  }

  Future<List<DoctorModel>> fetchAllDoctors() async {
    return await apiService.getDoctors(ApiConstants.getAllDoctors);
  }

  Future<List<DoctorSummary>> getAllDoctorsSummary() async {
    return await apiService
        .getAllDoctorsSummary(ApiConstants.getAllDoctorsSummary);
  }

  Future<DoctorModel> getDoctorById(int id) async {
    final res =
        await apiService.getDoctorById(ApiConstants.getAllDoctors, "eq.$id");
    return res.first;
  }

  Future<List<DoctorSummary>> getDoctorSpecialist(int specialtyId) async {
    return await apiService.getDoctorSpecialties(
        ApiConstants.getAllDoctorsSummary, "eq.$specialtyId");
  }

  Future<List<DoctorCommentModel>> getDoctorComments(int doctorid) async {
    return await apiService.getDoctorComments(
        ApiConstants.getComments, "eq.$doctorid");
  }
}
