import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/features/appointment/data/remote_data/appointments_remote_data.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos_imp.dart';
import 'package:tabibak/features/doctor/data/remote_data/doctor_remote_data.dart';
import 'package:tabibak/features/doctor/data/repo/doctor_repo.dart';
import 'package:tabibak/features/doctor/data/repo/doctor_repo_impl.dart';
import 'package:tabibak/features/home/data/data_source/home_remote_data.dart';
import 'package:tabibak/features/home/data/repo/home_repo.dart';
import 'package:tabibak/features/home/data/repo/home_repo_imp.dart';
import 'package:tabibak/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:tabibak/features/profile/data/repo/profile_repo.dart';
import 'package:tabibak/features/profile/data/repo/profile_repo_imp.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Supabase instance
  getIt.registerSingleton<Supabase>(Supabase.instance);

  // Repository
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepoImp(
        homeRemoteData: HomeRemoteData(supabase: getIt<Supabase>().client),
      ));

  getIt.registerLazySingleton<AppointmentsRepos>(() => AppointmentsReposImp(
        appointmentsRemoteData:
            AppointmentsRemoteData(supabase: getIt<Supabase>()),
      ));
  getIt.registerLazySingleton<DoctorRepo>(() => DoctorRepoImpl(
        doctorRemoteData: DoctorRemoteData(supabase: getIt<Supabase>()),
      ));
  getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepoImp(
        profileRemoteDataSource:
            ProfileRemoteDataSource(supabase: getIt<Supabase>()),
      ));
}
