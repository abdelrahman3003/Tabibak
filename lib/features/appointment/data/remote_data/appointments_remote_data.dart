import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/home/data/model/day_shift_model.dart';

class AppointmentsRemoteData {
  final Supabase supabase;

  AppointmentsRemoteData({required this.supabase});

  Future<void> addAppointment(AppointmentModel appointment) async {
    await supabase.client
        .from('appointments')
        .insert(appointment.toJsonForInsert());
  }

  Future<DayShiftsModel?> getDayShift(
      {required String dayEn, required int clinicId}) async {
    final response =
        await Supabase.instance.client.rpc('get_shift_by_day', params: {
      'p_day_en': dayEn,
      'p_clinic_id': clinicId,
    });
    if (response == null) return null;
    return DayShiftsModel.fromJson(response);
  }

  Future<List<AppointmentModel>> getAppointments() async {
    final response = await supabase.client
        .from('appointments')
        .select(
            "*,users(*),appointments_status(*),doctors(*,clinic_data(*),specialties(*)),shift_evening(*),shifts_morning(*)")
        .eq("user_id", supabase.client.auth.currentUser!.id);
    return response.map((e) => AppointmentModel.fromJson(e)).toList();
  }

  Future<void> deleteAppointment(int appointmentId) async {
    await supabase.client.from('appointments').delete().eq("id", appointmentId);
  }
}
