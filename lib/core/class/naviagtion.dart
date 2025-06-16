import 'package:flutter/material.dart';
import 'package:tabibak/core/class/routes.dart';
import 'package:tabibak/features/auth/signin/representation/view/signin_view.dart';
import 'package:tabibak/features/auth/signup/representation/view/signup_view.dart';

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
    default:
      return Scaffold(
        body: Center(child: Text('No route defined for $routeName')),
      );
  }
}
