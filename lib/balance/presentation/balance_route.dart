import 'package:equilibrium/balance/business/balance_bloc.dart';
import 'package:equilibrium/balance/presentation/balance_screen.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/presentation/model/bottom_navigation_type.dart';
import 'package:equilibrium/presentation/screen/main_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class BalanceRoute extends StatelessWidget {
  const BalanceRoute({super.key});

  static const route = "BalanceRoute";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BalanceBloc(
        repository: GetIt.I.get(),
        teamRepository: GetIt.I.get(),
        coach: GetIt.I.get(),
      )..add(BalanceLoadEvent()),
      child: BlocBuilder<BalanceBloc, BalanceState>(
        builder: (context, state) {
          final BalanceBloc bloc = context.read();
          return MainContainer(
            title: 'Balance',
            floatingActionButton: _buildFAB(bloc, state),
            currentBottomNavigation: BottomNavigationType.balance,
            child: BalanceScreen(
              bloc: bloc,
            ),
          );
        },
      ),
    );
  }

  _buildFAB(BalanceBloc bloc, BalanceState state) =>
      FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          _sendToBalanceArrivedPlayers(bloc, state);
        },
        child: const Icon(Icons.balance),
      );

  void _sendToBalanceArrivedPlayers(BalanceBloc bloc, BalanceState state) {
    switch (state) {
      case NotBalancedState():
        bloc.add(BalanceTeamsEvent(state.teamPresencePlayers));
      case BalancedTeamsState():
        bloc.add(BalanceTeamsEvent(state.players));
      case BalanceInitialState():
        print("Do nothing when BalanceInitialState");
    }
  }
}