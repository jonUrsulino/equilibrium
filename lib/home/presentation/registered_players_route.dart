import 'package:equilibrium/home/business_logic/registered_players_bloc.dart';
import 'package:equilibrium/home/presentation/registered_players_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class RegisteredPlayersRoute extends StatelessWidget {
  const RegisteredPlayersRoute({super.key});

  static const route = "RegisteredPlayersRoute";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisteredPlayersBloc(
          presencePlayerRepository: GetIt.I.get(),
      ),
      child: const RegisteredPlayersScreen(),
    );
  }

}