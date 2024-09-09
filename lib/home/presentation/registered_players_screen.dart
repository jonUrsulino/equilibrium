import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/home/business_logic/registered_players_bloc.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signals/signals_flutter.dart';

class RegisteredPlayersScreen extends StatelessWidget {
  const RegisteredPlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisteredPlayersBloc bloc = context.read();
    final initialPlayers = bloc.registeredPlayersSignals.watch(context);
    // final Computed<List<PresencePlayer>> computedPresencePlayersOrderedByName = bloc.presencePlayerRepository.getComputedPresencePlayersOrderedByName();
    // final initialPlayers = computedPresencePlayersOrderedByName.watch(context);
    return Column(
      children: [
        Text(
          'Marque os jogadores confirmados',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          'Jogadores nessa lista: ${initialPlayers.length}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: initialPlayers.length,
            itemBuilder: (context, index) {
              return PlayerTile(
                player:
                    initialPlayers[index].player,
                arrived: false,
                onChangeArriving: (value) => onChangeConfirmed(
                  bloc,
                  initialPlayers[index],
                  value,
                ),
                showStars: false,
              );
            },
          ),
        )
      ],
    );
  }

  onChangeConfirmed(RegisteredPlayersBloc bloc, PresencePlayer presencePlayer, value) {
    bloc.presencePlayerRepository.playerConfirmed(presencePlayer, value);
  }
}
