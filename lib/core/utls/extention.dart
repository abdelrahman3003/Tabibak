import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/utls/routes.dart';
import 'package:tabibak/features/auth/presentation/view/screens/forgrt_password_view.dart';
import 'package:tabibak/features/auth/presentation/view/screens/otp_verification_view.dart';
import 'package:tabibak/features/auth/presentation/view/screens/reset_password_sucess_view.dart';
import 'package:tabibak/features/auth/presentation/view/screens/reset_password_view.dart';
import 'package:tabibak/features/auth/presentation/view/screens/signin_view.dart';
import 'package:tabibak/features/auth/presentation/view/screens/signup_view.dart';
import 'package:tabibak/features/booking/booking_screen.dart';
import 'package:tabibak/features/home/presentation/views/screens/doctor_details_screen.dart';
import 'package:tabibak/features/home/presentation/views/screens/specialist_screen.dart';
import 'package:tabibak/features/layout/layout_screen.dart';
import 'package:tabibak/features/notification/notifcation_screen.dart';

extension Navigagtion on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).push(
      PageRouteBuilder(
        settings: RouteSettings(name: routeName, arguments: arguments),
        pageBuilder: (context, animation, secondaryAnimation) =>
            _getPageByRouteName(routeName, arguments),
        transitionDuration: Duration(milliseconds: 800),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // من اليمين
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required RoutePredicate predicate}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop() => Navigator.of(this).pop();
}

Widget _getPageByRouteName(String routeName, Object? arguments) {
  switch (routeName) {
    case Routes.singinView:
      return SigninView();
    case Routes.singupView:
      return SignupView();
    case Routes.layoutScreen:
      return LayoutScreen();
    case Routes.oTPVerificationScreen:
      return OTPVerificationScreen();
    case Routes.forgrtPasswordView:
      return ForgrtPasswordView();
    case Routes.resetPasswordView:
      return ResetPasswordView();
    case Routes.resetPasswordSucessView:
      return ResetPasswordSucessView();
    case Routes.specialistScreen:
      return SpecialistScreen();
    case Routes.doctorDetailsScreen:
      return DoctorDetailsScreen();
    case Routes.bookingScreen:
      return BookingScreen();
    case Routes.notifcationScreen:
      return NotifcationScreen();
    default:
      return Scaffold(
        body: Center(child: Text('No route defined for $routeName')),
      );
  }
}

extension DimensionsExt on num {
  SizedBox get hBox => SizedBox(height: toDouble().h);
  SizedBox get wBox => SizedBox(width: toDouble().w);
  BorderRadius get radius => BorderRadius.circular(toDouble().r);
  Radius get radiusCircular => Radius.circular(toDouble().r);
}
