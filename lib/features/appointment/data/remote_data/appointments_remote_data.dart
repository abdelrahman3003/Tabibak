import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/home/data/model/day_shift_model.dart';

class AppointmentsRemoteData {
  final Supabase supabase;

  AppointmentsRemoteData({required this.supabase});

  Future<void> addAppointment(AppointmentModel appointment) async {
    final payload = appointment.toJsonForInsert();
    // Edge function requires at least date + doctor + user + one shift.
    if (payload['appointment_date'] == null ||
        payload['doctor_id'] == null ||
        payload['user_id'] == null) {
      throw const AuthException('Missing appointment data');
    }
    if (payload['shift_morning_id'] == null &&
        payload['shift_evening_id'] == null) {
      throw const AuthException('Please select a period (morning/evening)');
    }
    final res = await supabase.client.functions
        .invoke("bright-responder", body: payload);
    if (res.status != 200) {
      throw PostgrestException(
        message: 'Booking failed (${res.status}): ${res.data}',
      );
    }
    final data = res.data;
    if (data is Map && data['success'] == false) {
      throw PostgrestException(
        message: data['error']?.toString() ?? 'Booking failed',
      );
    }
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
    final userId = supabase.client.auth.currentUser?.id;
    if (userId == null) throw const AuthException('User not logged in');
    final response = await supabase.client
        .from('appointments')
        .select(
            "*,users(*),appointments_status(*),appointment_types(*),doctors(*,clinic_data(*),specialties(*)),shift_evening:appointment_evening_shift_id(*),shifts_morning:appointment_morning_shift_id(*)")
        .eq("user_id", userId)
        .order('appointment_date', ascending: true);
    return (response as List)
        .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Cancels instead of hard-deleting so history + notifications stay intact.
  /// Status codes: 1 pending, 2 confirmed, 3 completed, 4 cancelled.
  Future<void> deleteAppointment(int appointmentId) async {
    await cancelAppointment(appointmentId);
  }

  Future<void> cancelAppointment(int appointmentId) async {
    final userId = supabase.client.auth.currentUser?.id;
    if (userId == null) throw const AuthException('User not logged in');
    // Prefer edge function so patient + doctor get inbox + FCM.
    try {
      final res = await supabase.client.functions.invoke(
        'update_appointment',
        body: {'appointment_id': appointmentId, 'status': 4},
      );
      if (res.status == 200 &&
          res.data is Map &&
          (res.data as Map)['success'] == true) {
        return;
      }
    } catch (_) {
      // Fall through to direct update.
    }
    await supabase.client
        .from('appointments')
        .update({'status': 4})
        .eq('id', appointmentId)
        .eq('user_id', userId);
  }

  Future<int?> getAppointmentQueueById(int appointmentId) async {
    final response = await supabase.client.rpc(
      'get_appointment_queue_by_id',
      params: {
        'p_appointment_id': appointmentId,
      },
    );
    if (response == null) return null;
    if (response is Map) {
      final q = response['queue'];
      if (q is num) return q.toInt();
      if (q is String) return int.tryParse(q);
      final first = response.values.isNotEmpty ? response.values.first : null;
      if (first is num) return first.toInt();
      if (first is String) return int.tryParse(first);
      return null;
    }
    if (response is List && response.isNotEmpty) {
      final first = response.first;
      if (first is Map && first['queue'] is num) {
        return (first['queue'] as num).toInt();
      }
    }
    return null;
  }
}
