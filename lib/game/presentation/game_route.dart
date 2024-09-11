import 'package:equilibrium/game/business_logic/game_bloc.dart';
import 'package:equilibrium/game/presentation/game_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class GameRoute extends StatelessWidget {
  const GameRoute({super.key});

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
      child: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          final GameBloc bloc = context.read();
          return GameScreen(
              bloc: bloc
          );
        },
      ),
    );
  }
}