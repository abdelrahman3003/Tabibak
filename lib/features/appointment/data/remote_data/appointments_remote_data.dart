import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/home/data/model/shift_model.dart';

class AppointmentsRemoteData {
  final Supabase supabase;

  AppointmentsRemoteData({required this.supabase});

  Future<void> addAppointment(AppointmentModel appointment) async {
    await supabase.client.from('doctors').insert(appointment.toJson());
  }

  Future<ShiftModel?> getShift(
      {required String dayEn, required int clinicId}) async {
    final response =
        await Supabase.instance.client.rpc('get_shift_by_day', params: {
      'p_day_en': dayEn,
      'p_clinic_id': clinicId,
    });
    if (response == null) return null;
    return ShiftModel.fromJson(response);
  }
}
