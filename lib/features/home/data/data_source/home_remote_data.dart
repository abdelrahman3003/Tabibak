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
    final response =
        await supabase.from('doctors').select(ApiConstants.getDoctors).limit(5);

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

  Future<List<DoctorModel>> getSpecialtiesDoctors(int specialtyId) async {
    final response = await supabase
        .from('doctors')
        .select(ApiConstants.getDoctors)
        .eq("specialty", specialtyId);
    return response.map((doctor) => DoctorModel.fromJson(doctor)).toList();
  }

  Future<List<DoctorModel>> searchDoctor(String search) async {
    final response =
        await supabase.from('doctors').select('*').ilike('name', '%$search%');

    return (response as List).map((e) => DoctorModel.fromJson(e)).toList();
  }
}
