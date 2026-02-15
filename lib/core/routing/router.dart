import 'package:flutter/material.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/presentaion/view/screens/appointment_booking_screen.dart';
import 'package:tabibak/features/appointment/presentaion/view/screens/appointment_details_screen.dart';
import 'package:tabibak/features/appointment/presentaion/view/screens/booking_success_screen.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/appointment_success_arg.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/auth/presentation/view/screens/forget_password_screen.dart';
import 'package:tabibak/features/auth/presentation/view/screens/otp_verification_screen.dart';
import 'package:tabibak/features/auth/presentation/view/screens/reset_password_screen.dart';
import 'package:tabibak/features/auth/presentation/view/screens/reset_password_sucess_screen.dart';
import 'package:tabibak/features/auth/presentation/view/screens/signin_screen.dart';
import 'package:tabibak/features/auth/presentation/view/screens/signup_screen.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/screens/all_specialties_screen.dart';
import 'package:tabibak/features/home/presentation/views/screens/layout_screen.dart';
import 'package:tabibak/features/home/presentation/views/screens/specialist_screen.dart';
import 'package:tabibak/features/notification/notifcation_screen.dart';
import 'package:tabibak/features/splash/splash_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case Routes.splashScreen:
        return _buildSlideRoute(SplashScreen());
      case Routes.singInScreen:
        return _buildSlideRoute(SigninScreen());
      case Routes.singUpScreen:
        return _buildSlideRoute(SignupView());
      case Routes.forgetPasswordScreen:
        return _buildSlideRoute(ForgetPasswordScreen(), settings: setting);
      case Routes.oTPVerificationScreen:
        final user = setting.arguments as UserModel;
        return _buildSlideRoute(
          OtpVerificationScreen(userModel: user),
          settings: setting,
        );

      case Routes.resetPasswordScreen:
        return _buildSlideRoute(const ResetPasswordScreen(), settings: setting);
      case Routes.layoutScreen:
        return _buildSlideRoute(const LayoutScreen());
      case Routes.specialistScreen:
        return _buildSlideRoute(const SpecialistScreen());

      case Routes.appointmentBookingScreen:
        final doctorModel = setting.arguments as DoctorModel;
        return _buildSlideRoute(
            AppointmentBookingScreen(doctorModel: doctorModel));
      case Routes.appointmentDetailsScreen:
        final appointment = setting.arguments as AppointmentModel;
        return _buildSlideRoute(
            AppointmentDetailsScreen(appointment: appointment));
      case Routes.bookingSuccessScreen:
        final args = setting.arguments as AppointmentSuccessArg;

        return _buildSlideRoute(
            BookingSuccessScreen(appointmentSuccessArg: args));
      case Routes.resetPasswordSuccessScreen:
        return _buildSlideRoute(const ResetPasswordSuccessScreen());
      case Routes.notificationScreen:
        return _buildSlideRoute(const NotificationScreen());
      case Routes.allSpecialtiesScreen:
        return _buildSlideRoute(const AllSpecialtiesScreen());

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

  static PageRoute _buildSlideRoute(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      settings: settings,
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
