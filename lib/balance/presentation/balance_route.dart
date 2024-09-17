import 'package:equilibrium/balance/business/balance_bloc.dart';
import 'package:equilibrium/balance/presentation/balance_screen.dart';
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
      child: Builder(
        builder: (context) {
          final BalanceBloc bloc = context.read();
          return MainContainer(
            title: 'Balance',
            floatingActionButton: _buildFAB(bloc),
            currentBottomNavigation: BottomNavigationType.balance,
            child: BalanceScreen(
              bloc: bloc,
            ),
          );
        },
      ),
    );
  }

  _buildFAB(BalanceBloc bloc) =>
      FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          bloc.add(BalanceTeamsEvent());
        },
        child: const Icon(Icons.balance),
      );
}