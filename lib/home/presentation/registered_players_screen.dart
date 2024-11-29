import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/home/business_logic/registered_players_bloc.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisteredPlayersScreen extends StatelessWidget {
  const RegisteredPlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisteredPlayersBloc bloc = context.read();
    // final initialPlayers = bloc.registeredPlayersSignals.watch(context);
    final streamInitialPlayers = bloc.registeredPlayersStream;

    return StreamBuilder<List<PresencePlayer>>(
      stream: streamInitialPlayers,
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return Container();
        }

        final List<PresencePlayer> initialPlayers = snapshot.requireData;

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
    );
  }

  onChangeConfirmed(RegisteredPlayersBloc bloc, PresencePlayer presencePlayer, value) {
    bloc.presencePlayerRepository.playerConfirmed(presencePlayer, value);
  }
}
