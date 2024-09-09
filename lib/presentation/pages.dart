import 'package:equilibrium/home/presentation/home_route.dart';
import 'package:equilibrium/home/presentation/home_screen.dart';
import 'package:equilibrium/presentation/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class Pages {
  static GoRouter routes = GoRouter(
      navigatorKey: GetIt.I<GlobalKey<NavigatorState>>(),
      initialLocation: "/",
      routes: [
        GoRoute(
          path: "/",
          name: HomeRoute.route,
          builder: (context, state) => const HomeRoute(),
        ),
        GoRoute(
          path: "/settings",
          name: SettingsScreen.route,
          builder: (context, state) => const SettingsScreen(),
        ),
      ]);
}
