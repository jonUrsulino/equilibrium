import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class CancelingConfirmationBottomSheet extends StatelessWidget {
  const CancelingConfirmationBottomSheet({
    super.key,
    required this.repository,
  });

  final PresencePlayerRepository repository;

  @override
  Widget build(BuildContext context) {
    // final confirmedPlayers = repository.getComputedConfirmedPresencePlayers().watch(context);
    final streamConfirmedPlayers = repository.getStreamPresencePlayersWhere(StatePresence.confirmed);

    return StreamBuilder<List<PresencePlayer>>(
      stream: streamConfirmedPlayers,
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return Container();
        }

        final List<PresencePlayer> confirmedPlayers = snapshot.requireData;

        return Column(
          children: [
            Text(
              'Marque quem cancelou: ${confirmedPlayers.length}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Expanded(
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: confirmedPlayers.length,
                itemBuilder: (context, index) {
                  return PlayerTile(
                    player: confirmedPlayers[index].player,
                    arrived: false,
                    onChangeArriving: (value) => onChangeCanceled(
                      confirmedPlayers[index],
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

  onChangeCanceled(PresencePlayer presencePlayer, value) {
    repository.playerCanceled(presencePlayer);
  }
}
