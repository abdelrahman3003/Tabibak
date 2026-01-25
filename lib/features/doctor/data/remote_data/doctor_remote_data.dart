import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_consatnt.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class DoctorRemoteData {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<DoctorModel> getDoctor(String doctorId) async {
    final response = await supabase
        .from('doctors')
        .select(ApiConstants.getDoctors)
        .eq("doctor_id", doctorId)
        .single();
    return DoctorModel.fromJson(response);
  }
}
