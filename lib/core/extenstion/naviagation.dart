import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  // Push a new route onto the navigator stack
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  // Push a new route onto the navigator stack and remove the previous one
  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  // Push a new route onto the navigator stack and remove all previous routes
  Future<dynamic> pushNamedAndRemoveUntil(
    String newRouteName,
    bool Function(Route<dynamic> route) predicate, {
    Object? arguments,
  }) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil(newRouteName, predicate, arguments: arguments);
  }

  void popUntil(
    BuildContext context,
    bool Function(Route<dynamic>) predicate,
  ) =>
      Navigator.popUntil(this, predicate);

  // Pop the current route off the navigator stack
  void pop() => Navigator.pop(this);
}
