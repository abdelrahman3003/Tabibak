import 'package:flutter/material.dart';
import 'package:tabibak/features/auth/presentation/view/forgrt_password_view.dart';
import 'package:tabibak/features/auth/presentation/view/reset_password_sucess_view.dart';
import 'package:tabibak/features/auth/presentation/view/reset_password_view.dart';
import 'package:tabibak/features/auth/presentation/view/signin_view.dart';
import 'package:tabibak/features/auth/presentation/view/signup_view.dart';
import 'package:tabibak/features/booking/booking_screen.dart';
import 'package:tabibak/features/home/presentation/views/doctor_details_screen.dart';
import 'package:tabibak/features/home/presentation/views/specialist_screen.dart';
import 'package:tabibak/features/layout/layout_screen.dart';
import 'package:tabibak/features/notification/notifcation_screen.dart';

import '../../features/auth/presentation/view/otp_verification_view.dart';

class Routes {
  static const String singinView = '/singinView';
  static const String singupView = '/singupView';
  static const String forgrtPasswordView = '/forgrtPasswordView';
  static const String resetPasswordView = '/resetPasswordView';
  static const String oTPVerificationScreen = '/oTPVerificationScreen';
  static const String layoutScreen = '/layoutScreen';
  static const String specialistScreen = '/specialistScreen';
  static const String doctorDetailsScreen = '/doctorDetailsScreen';
  static const String bookingScreen = '/bookingScreen';
  static const String resetPasswordSucessView = '/resetPasswordSucessView';
  static const String notifcationScreen = '/notifcationScreen';

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
      case forgrtPasswordView:
        return MaterialPageRoute(
          builder: (context) => const ForgrtPasswordView(),
        );
      case oTPVerificationScreen:
        return MaterialPageRoute(
          builder: (context) => const OTPVerificationScreen(),
        );
      case resetPasswordView:
        return MaterialPageRoute(
          builder: (context) => const ResetPasswordView(),
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
      case resetPasswordSucessView:
        return MaterialPageRoute(
          builder: (context) => const ResetPasswordSucessView(),
        );
      case notifcationScreen:
        return MaterialPageRoute(
          builder: (context) => const NotifcationScreen(),
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
