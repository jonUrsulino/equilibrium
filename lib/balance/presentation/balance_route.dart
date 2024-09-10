import 'package:equilibrium/balance/business/balance_bloc.dart';
import 'package:equilibrium/balance/presentation/balance_screen.dart';
import 'package:flutter/cupertino.dart';
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
      ),
      child: const BalanceScreen(),
    );
  }
}