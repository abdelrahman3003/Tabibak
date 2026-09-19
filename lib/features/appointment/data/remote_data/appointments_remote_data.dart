import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/home/data/model/day_shift_model.dart';

class AppointmentsRemoteData {
  final Supabase supabase;

  AppointmentsRemoteData({required this.supabase});

  Future<List<String>> getAvailableDates({required int clinicId}) async {
    final now = DateTime.now();
    final startOfMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}-01';
    final endOfMonth = DateTime(now.year, now.month + 1, 0)
        .toString()
        .split(' ')[0];

    final response = await supabase.client
        .from('working_day')
        .select('day_id')
        .eq('clinic_id', clinicId)
        .gte('created_at', startOfMonth)
        .lte('created_at', endOfMonth)
        .neq('is_selected', false);

    if (response == null || response.isEmpty) return [];

    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return (response as List)
        .map((e) => dayNames[(e['day_id'] as int) - 1])
        .cast<String>()
        .toList();
  }

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
