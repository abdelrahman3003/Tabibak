import 'package:flutter/material.dart';
import 'package:tabibak/features/auth/signin/representation/view/signin_view.dart';
import 'package:tabibak/features/auth/signup/representation/view/signup_view.dart';

class Routes {
  static const String singinView = '/singinView';
  static const String singupView = '/singupView';

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
