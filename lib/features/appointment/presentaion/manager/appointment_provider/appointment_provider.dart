// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tabibak/features/appointment/data/repos/appointments_repos.dart';
// import 'package:tabibak/features/appointment/data/repos/appointments_repos_imp.dart';
// import 'package:tabibak/features/appointment/presentaion/manager/appointment_provider/appointment_states.dart';

// final appointmentsRepos = StateProvider<AppointmentsRepos>(
//   (ref) => AppointmentsReposImp(),
// );
// final appointmentProviderNotifer =
//     StateNotifierProvider.autoDispose<AppointmentProvider, AppointmentStates>(
//   (ref) => AppointmentProvider(ref),
// );

// class AppointmentProvider extends StateNotifier<AppointmentStates> {
//   AppointmentProvider(this.ref) : super(AppointmentStates()) {
//   }
//   final Ref ref;
//   final SupabaseClient supabase = Supabase.instance.client;
//   iniData() {
//     getAllAppoinments();
//   }

//   void getAllAppoinments() async {
//     final userId = Supabase.instance.client.auth.currentUser?.id;
//     state = AppointmentStates(isLoading: true);
//     final result = await ref.read(appointmentsRepos).getAllAppoinments(userId!);
//     result.when(
//       sucess: (data) {
//         state = AppointmentStates(appointmentList: data);
//       },
//       failure: (apiErrorModel) {
//         state = AppointmentStates(errorMessage: apiErrorModel.message);
//       },
//     );
//   }

//   void getAllAppoinmentsStatus() async {
//     state = AppointmentStates(isLoading: true);
//     final result = await ref.read(appointmentsRepos).getAllAppoinmentsStatus();
//     result.when(
//       sucess: (data) {
//         state = AppointmentStates(appointmentStatesList: data);
//       },
//       failure: (apiErrorModel) {
//         state = AppointmentStates(errorMessage: apiErrorModel.message);
//       },
//     );
//   }
// }
