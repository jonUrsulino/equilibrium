import 'package:equilibrium/home/business_logic/arrived_players_bloc.dart';
import 'package:equilibrium/home/presentation/arrived_players_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ArrivedPlayersRoute extends StatelessWidget {
  const ArrivedPlayersRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArrivedPlayersBloc(
        repository: GetIt.I.get(),
        getComputedArrivedPresencePlayers: GetIt.I.get(),
      ),
      child: const ArrivedPlayersScreen(),
    );
  }
}