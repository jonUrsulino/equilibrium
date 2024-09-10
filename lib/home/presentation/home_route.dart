import 'package:equilibrium/home/business_logic/home_bloc.dart';
import 'package:equilibrium/home/presentation/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  static const route = "HomeRoute";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeBloc(
          controllerManager: GetIt.I.get(),
          repository: GetIt.I.get(),
          coach: GetIt.I.get(),
          settings: GetIt.I.get(),
        ),
        child: const HomeScreen()
    );
  }
}