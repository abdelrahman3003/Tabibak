import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tabibak/core/networking/api_consatnt.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  //Get all doctors
  @GET("/doctors")
  Future<List<DoctorModel>> getDoctors(
    @Query("select") String selectFields,
  );
}
