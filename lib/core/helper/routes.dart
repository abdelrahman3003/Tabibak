import 'package:flutter/material.dart';
import 'package:tabibak/features/auth/presentation/view/signin_view.dart';
import 'package:tabibak/features/auth/presentation/view/signup_view.dart';
import 'package:tabibak/features/booking/booking_screen.dart';
import 'package:tabibak/features/home/presentation/views/doctor_details_screen.dart';
import 'package:tabibak/features/home/presentation/views/specialist_screen.dart';
import 'package:tabibak/features/layout/layout_screen.dart';

class Routes {
  static const String singinView = '/singinView';
  static const String singupView = '/singupView';
  static const String layoutScreen = '/layoutScreen';
  static const String specialistScreen = '/specialistScreen';
  static const String doctorDetailsScreen = '/doctorDetailsScreen';
  static const String bookingScreen = '/bookingScreen';

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
      case layoutScreen:
        return MaterialPageRoute(
          builder: (context) => const LayoutScreen(),
        );
      case specialistScreen:
        return MaterialPageRoute(
          builder: (context) => const SpecialistScreen(),
        );
      case doctorDetailsScreen:
        return MaterialPageRoute(
          builder: (context) => const DoctorDetailsScreen(),
        );
      case bookingScreen:
        return MaterialPageRoute(
          builder: (context) => const BookingScreen(),
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
