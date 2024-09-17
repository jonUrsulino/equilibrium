import 'package:equilibrium/home/presentation/home_screen.dart';
import 'package:flutter/cupertino.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  static const route = "HomeRoute";

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}