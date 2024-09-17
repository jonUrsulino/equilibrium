import 'package:equilibrium/balance/presentation/balance_route.dart';
import 'package:equilibrium/game/presentation/game_route.dart';
import 'package:equilibrium/home/presentation/home_route.dart';
import 'package:equilibrium/home/presentation/presence_route.dart';
import 'package:equilibrium/settings/presentation/settings.dart';
import 'package:equilibrium/settings/presentation/settings_route.dart';
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
          name: PresenceRoute.route,
          pageBuilder: (context, state) => const NoTransitionPage(
              child: PresenceRoute()
          ),
        ),
        GoRoute(
            path: "/balance",
            name: BalanceRoute.route,
            pageBuilder: (context, state) => const NoTransitionPage(
                child: BalanceRoute()
            ),
        ),
        GoRoute(
          path: "/game",
          name: GameRoute.route,
          pageBuilder: (context, state) => const NoTransitionPage(
              child: GameRoute()
          ),
          builder: (context, state) => const GameRoute(),
        ),
        GoRoute(
          path: "/settings",
          name: SettingsRoute.route,
          pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsRoute()
          ),
        ),
      ]);
}
