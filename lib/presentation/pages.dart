import 'package:equilibrium/presentation/screen/balance_screen.dart';
import 'package:equilibrium/presentation/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:equilibrium/presentation/screen/home.dart';

class Pages {
  static GoRouter routes = GoRouter(
      navigatorKey: GetIt.I<GlobalKey<NavigatorState>>(),
      initialLocation: "/",
      routes: [
        GoRoute(
          path: "/",
          name: HomeScreen.route,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: "/settings",
          name: SettingsScreen.route,
          builder: (context, state) => const SettingsScreen(),
        ),
      ]);
}
