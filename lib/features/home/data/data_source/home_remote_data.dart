import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_consatnt.dart';
import 'package:tabibak/core/networking/api_service.dart';
import 'package:tabibak/core/networking/dio_factory.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/comment_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';

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

  Future<List<SpecialtyModel>> getSpecialties() async {
    final response = await supabase.from('specialties').select();
    return response.map((e) => SpecialtyModel.fromJson(e)).toList();
  }

  Future<List<DoctorModel>> fetchAllDoctors() async {
    return await apiService.getDoctors(ApiConstants.getAllDoctors);
  }

  Future<List<DoctorModel>> searchDoctor(String search) async {
    return await apiService.searchDoctor(
        ApiConstants.getAllDoctorsSummary, "ilike.*$search*");
  }

  Future<List<DoctorModel>> getTopDoctors() async {
    final response = await supabase
        .from('doctors')
        .select(
            "*,specialties(*),education(*),clinic_data(*,clinic_address(*),working_day(*,shifts(*),days(*))),comments(*),ratings(*)")
        .limit(5);

    return response.map((doctor) => DoctorModel.fromJson(doctor)).toList();
  }

  Future<DoctorModel> getDoctorById(String doctorId) async {
    final response = await supabase
        .from('doctors')
        .select(
            "*,specialties(*),education(*),clinic_data(*,clinic_address(*),working_day(*,shifts(*),days(*))),comments(*),ratings(*)")
        .eq('doctor_id', doctorId)
        .single();

    return DoctorModel.fromJson(response);
  }

  Future<List<DoctorModel>> getDoctorSpecialist(int specialtyId) async {
    return [];
  }

  Future<List<CommentModel>> getDoctorComments(int doctorid) async {
    return await apiService.getDoctorComments(
        ApiConstants.getComments, "eq.$doctorid", 7);
  }

  Future<void> addComment(
      {required String comment, required int doctorId}) async {
    return await apiService.addComment({
      "user_id": supabase.auth.currentUser!.id,
      "doctor_id": doctorId,
      "comment": comment,
    });
  }

  Future<void> addRate({required double rate, required int doctorId}) async {
    return await apiService.addRate({
      "user_id": supabase.auth.currentUser!.id,
      "doctor_id": doctorId,
      "rate": rate.toInt(),
    });
  }
}
