import 'package:flutter/material.dart';

/// Global navigator key so notification taps (FCM / local notifications)
/// can navigate even when triggered outside of a BuildContext.
class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return key.currentState!.pushNamed(routeName, arguments: arguments);
  }
}
