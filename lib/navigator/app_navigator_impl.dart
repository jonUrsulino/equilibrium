import 'dart:async';

import 'package:equilibrium/navigator/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigatorImpl extends AppNavigator {
  AppNavigatorImpl({
    required this.navigatorKey,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  void pop<T>({T? result}) {
    navigatorKey.currentContext?.pop(result as T);
  }

  @override
  FutureOr<T?>? navigateToScreen<T>({
    required String name,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    return navigatorKey.currentContext?.pushNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  @override
  void navigateToScreenAndClearBackStack({
    required String name,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    navigatorKey.currentContext?.pushReplacementNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }
}
