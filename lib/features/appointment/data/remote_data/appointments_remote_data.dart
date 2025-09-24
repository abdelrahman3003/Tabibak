import 'package:tabibak/core/networking/api_consatnt.dart';
import 'package:tabibak/core/networking/api_service.dart';
import 'package:tabibak/core/networking/dio_factory.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class AppointmentsRemoteData {
  final ApiService apiService = ApiService(DioFactory.getDio());
  Future<List<Appointment>> getAllAppoinments(String userId) async {
    return await apiService.getAllAppointment(
        ApiConstants.getAllAppoinments, userId);
  }

  Future<List<AppointmentStatus>> getAllAppoinmentsStatus() async {
    return await apiService
        .getAllAppointmentStatus(ApiConstants.getAllAppoinments);
  }

  Future<List<ClinicWorkingDay>> getTimeSlots(
      int clinicId, String workingDay) async {
    return await apiService.getTimeSlots(
        ApiConstants.getTimeSlots, "eq.$workingDay", "eq.$clinicId");
  }
}
