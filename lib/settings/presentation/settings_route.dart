
import 'package:equilibrium/presentation/model/bottom_navigation_type.dart';
import 'package:equilibrium/presentation/screen/main_container.dart';
import 'package:equilibrium/settings/presentation/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  static const route = 'SettingsRoute';

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      title: 'Ajustes',
      currentBottomNavigation: BottomNavigationType.settings,
      child: SettingsScreen(),
    );
  }
}