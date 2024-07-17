import 'dart:async';

abstract class AppNavigator {
  void pop<T>({T? result});

  void navigateToScreenAndClearBackStack({
    required String name,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  });

  FutureOr<T?>? navigateToScreen<T>({
    required String name,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  });
}
