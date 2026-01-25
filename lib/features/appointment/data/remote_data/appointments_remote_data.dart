import 'package:tabibak/core/networking/api_consatnt.dart';
import 'package:tabibak/core/networking/api_service.dart';
import 'package:tabibak/core/networking/dio_factory.dart';
import 'package:tabibak/features/appointment/data/model/appointment_body.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/home/data/model/working_day_model.dart';

class AppointmentsRemoteData {
  final ApiService apiService = ApiService(DioFactory.getDio());
  Future<List<Appointment>> getAllAppoinments(String userId) async {
    return await apiService.getAllAppointment(
        ApiConstants.getAllAppoinments, userId, "appointment_time.desc");
  }

  Future<List<AppointmentStatus>> getAllAppoinmentsStatus() async {
    return await apiService
        .getAllAppointmentStatus(ApiConstants.getAllAppoinments);
  }

  Future<List<WorkingDay>> getTimeSlots(int clinicId, String workingDay) async {
    return [];
  }

  Future<void> addAppointment(AppointmentBody appointmentBody) async {
    return await apiService.addAppointment(appointmentBody);
  }

  Future<void> deleteAppointment(int id) async {
    return await apiService.deleteAppointment("eq.$id");
  }
}
