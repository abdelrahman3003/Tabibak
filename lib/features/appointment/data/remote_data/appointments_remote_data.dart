import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/home/data/model/day_shift_model.dart';

class AppointmentsRemoteData {
  final Supabase supabase;

  AppointmentsRemoteData({required this.supabase});

  Future<void> addAppointment(
    AppointmentModel appointment,
  ) async {
    final response = await supabase.client.functions.invoke(
      'bright-responder',
      body: appointment.toJsonForInsert(),
    );

    if (response.status != 200) {
      throw PostgrestException(message: 'Booking failed');
    }
  }

  Future<DayShiftsModel?> getDayShift({
    required String dayEn,
    required int clinicId,
  }) async {
    final response = await supabase.client.rpc(
      'get_shift_by_day',
      params: {
        'p_day_en': dayEn,
        'p_clinic_id': clinicId,
      },
    );

    if (response == null) return null;

    return DayShiftsModel.fromJson(response);
  }

  Future<List<AppointmentModel>> getAppointments() async {
    final userId = supabase.client.auth.currentUser!.id;

    final response = await supabase.client
        .from('appointments')
        .select(
          '''
          *,
          users(*),
          appointments_status(*),
          appointment_types(*),
          doctors(
            *,
            clinic_data(*),
            specialties(*)
          ),
          shift_evening:appointment_evening_shift_id(*),
          shifts_morning:appointment_morning_shift_id(*)
          ''',
        )
        .eq('user_id', userId)
        .order(
          'appointment_date',
          ascending: true,
        );

    return (response as List)
        .map(
          (e) => AppointmentModel.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<AppointmentModel> getAppointmentById(
    int appointmentId,
  ) async {
    final response = await supabase.client
        .from('appointments')
        .select(
          '''
          *,
          users(*),
          appointments_status(*),
          appointment_types(*),
          doctors(
            *,
            clinic_data(*),
            specialties(*)
          ),
          shift_evening:appointment_evening_shift_id(*),
          shifts_morning:appointment_morning_shift_id(*)
          ''',
        )
        .eq('id', appointmentId)
        .single();

    return AppointmentModel.fromJson(response);
  }

  Future<void> deleteAppointment(
    int appointmentId,
  ) async {
    await cancelAppointment(appointmentId);
  }

  Future<void> cancelAppointment(
    int appointmentId,
  ) async {
    await supabase.client.functions.invoke(
      'update_appointment',
      body: {
        'appointment_id': appointmentId,
        'status': 4,
      },
    );
  }
}
