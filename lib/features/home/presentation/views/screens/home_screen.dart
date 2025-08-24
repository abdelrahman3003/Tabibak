import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/utls/extention.dart';
import 'package:tabibak/core/utls/string_constants.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/categories_list/categories_list_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/doctors_list/doctor_list_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/titel_text.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/welcom_panner.dart';

import '../widget/home_screen/home_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final supabase = Supabase.instance.client;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen(
      (event) async {
        if (event.event == AuthChangeEvent.signedIn) {
          await FirebaseMessaging.instance.requestPermission();

          await FirebaseMessaging.instance.getAPNSToken();

          final fcmToken = await FirebaseMessaging.instance.getToken();

          if (fcmToken != null) {
            await setFcmToken(fcmToken);
          }
          FirebaseMessaging.instance.onTokenRefresh.listen(
            (fcmToken) async {
              await setFcmToken(fcmToken);
            },
          );
        }
      },
    );
  }

  Future<void> setFcmToken(String fcmToken) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      await supabase
          .from('users')
          .update({'fcm_token': fcmToken}).eq('user_id', userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: HomeAppbar(),
        ),
        20.hBox,
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: WelcomPanner()),
        40.hBox,
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TitelText(title: StringConstants.doctorSpeciality.tr())),
        20.hBox,
        CategoriesListStates(),
        20.hBox,
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TitelText(title: StringConstants.recommendationDoctor.tr())),
        20.hBox,
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DoctorListStates(),
        ))
      ],
    );
  }
}
