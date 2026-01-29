import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/features/home/data/data_source/home_remote_data.dart';
import 'package:tabibak/features/home/data/repo/home_repo.dart';
import 'package:tabibak/features/home/data/repo/home_repo_imp.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Supabase instance
  getIt.registerSingleton<Supabase>(Supabase.instance);

  //! Home Feature
  // Repository
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepoImp(
        homeRemoteData: HomeRemoteData(supabase: getIt<Supabase>().client),
      ));

  // StateNotifier / Provider
  // Controller / StateNotifier
}
