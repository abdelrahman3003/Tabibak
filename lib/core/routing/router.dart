import 'package:flutter/material.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/presentaion/view/screens/appointment_booking_screen.dart';
import 'package:tabibak/features/appointment/presentaion/view/screens/appointment_details_screen.dart';
import 'package:tabibak/features/auth/presentation/view/screens/forgrt_password_view.dart';
import 'package:tabibak/features/auth/presentation/view/screens/otp_verification_view.dart';
import 'package:tabibak/features/auth/presentation/view/screens/reset_password_sucess_view.dart';
import 'package:tabibak/features/auth/presentation/view/screens/reset_password_view.dart';
import 'package:tabibak/features/auth/presentation/view/screens/signin_view.dart';
import 'package:tabibak/features/auth/presentation/view/screens/signup_view.dart';
import 'package:tabibak/features/doctor_details/presentaion/views/screens/doctor_details_screen.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/screens/layout_screen.dart';
import 'package:tabibak/features/home/presentation/views/screens/specialist_screen.dart';
import 'package:tabibak/features/notification/notifcation_screen.dart';
import 'package:tabibak/features/splash/splash_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case Routes.splashScreen:
        return _buildSlideRoute(SplashScreen());
      case Routes.singinView:
        return _buildSlideRoute(SigninView());
      case Routes.singupView:
        return _buildSlideRoute(SignupView());
      case Routes.forgrtPasswordView:
        return _buildSlideRoute(ForgrtPasswordView());
      case Routes.oTPVerificationScreen:
        return _buildSlideRoute(OTPVerificationScreen());

      case Routes.resetPasswordView:
        return _buildSlideRoute(const ResetPasswordView());
      case Routes.layoutScreen:
        return _buildSlideRoute(const LayoutScreen());
      case Routes.specialistScreen:
        return _buildSlideRoute(const SpecialistScreen());
      case Routes.doctorDetailsScreen:
        return _buildSlideRoute(const DoctorDetailsScreen());
      case Routes.appointmentBookingScreen:
        final doctorModel = setting.arguments as DoctorModel;
        return _buildSlideRoute(
            AppointmentBookingScreen(doctorModel: doctorModel));
      case Routes.appointmentDetailsScreen:
        final appointment = setting.arguments as Appointment;
        return _buildSlideRoute(
            AppointmentDetailsScreen(appointment: appointment));
      case Routes.resetPasswordSucessView:
        return _buildSlideRoute(const ResetPasswordSucessView());
      case Routes.notifcationScreen:
        return _buildSlideRoute(const NotifcationScreen());

      default:
        return _buildSlideRoute(
          Scaffold(
            body: Center(
              child: Text("No route defined for ${setting.name}"),
            ),
          ),
        );
    }
  }

  static PageRoute _buildSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
