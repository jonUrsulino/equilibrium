import 'package:equilibrium/home/business_logic/confirmed_players_bloc.dart';
import 'package:equilibrium/home/presentation/confirmed_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ConfirmedPlayersRoute extends StatelessWidget {
  const ConfirmedPlayersRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfirmedPlayersBloc(
        repository: GetIt.I.get(),
      ),
      child: const ConfirmedBottomSheet(),
    );
  }
}