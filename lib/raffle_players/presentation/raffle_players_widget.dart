
import 'package:equilibrium/raffle_players/business_logic/raffle_players_bloc.dart';
import 'package:equilibrium/raffle_players/presentation/raffle_players_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RafflePlayersWidget extends StatelessWidget {
  const RafflePlayersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RafflePlayersBloc(),
      child: Builder(
        builder: (context) {
          final RafflePlayersBloc bloc = context.read();
          return RafflePlayersComponent(bloc: bloc);
        }
      ),
    );
  }


}