import 'package:equilibrium/game/business_logic/game_bloc.dart';
import 'package:equilibrium/game/presentation/game_screen.dart';
import 'package:equilibrium/presentation/model/bottom_navigation_type.dart';
import 'package:equilibrium/presentation/screen/main_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class GameRoute extends StatelessWidget {
  const GameRoute({super.key});

  static const route = "GameRoute";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      GameBloc(
          presencePlayerRepository: GetIt.I.get(),
          teamRepository: GetIt.I.get(),
          controller: GetIt.I.get(),
          settings: GetIt.I.get()
      )..add(LoadGameEvent()),
      child: Builder(
        builder: (context) {
          final GameBloc bloc = context.read();
          return MainContainer(
            title: 'Balance',
            floatingActionButton: _buildFAB(bloc),
            currentBottomNavigation: BottomNavigationType.game,
            child: GameScreen(
                bloc: bloc
            ),
          );
        },
      ),
    );
  }

  _buildFAB(GameBloc bloc) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () {},
      child: const Icon(Icons.play_arrow),
    );
  }
}