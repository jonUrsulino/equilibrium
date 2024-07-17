import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'app_navigator.dart';

extension NavExtension on BuildContext {
  AppNavigator get navigator => GetIt.I<AppNavigator>();
}
