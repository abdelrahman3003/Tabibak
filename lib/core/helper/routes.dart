import 'package:flutter/material.dart';
import 'package:tabibak/features/auth/presentation/view/signin_view.dart';
import 'package:tabibak/features/auth/presentation/view/signup_view.dart';
import 'package:tabibak/features/home/presentation/views/specialist_screen.dart';
import 'package:tabibak/features/layout/layout_screen.dart';

class Routes {
  static const String singinView = '/singinView';
  static const String singupView = '/singupView';
  static const String homeView = '/homeView';
  static const String specialistScreen = '/specialistScreen';

  static Route generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case singinView:
        return MaterialPageRoute(
          builder: (context) => const SigninView(),
        );
      case singupView:
        return MaterialPageRoute(
          builder: (context) => const SignupView(),
        );
      case homeView:
        return MaterialPageRoute(
          builder: (context) => const LayoutScreen(),
        );
      case specialistScreen:
        return MaterialPageRoute(
          builder: (context) => const SpecialistScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text("No route defind for ${setting.name}"),
            ),
          ),
        );
    }
  }
}
