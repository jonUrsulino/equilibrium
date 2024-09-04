import 'package:equilibrium/domain/home_arriving_player.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class CancelingConfirmationBottomSheet extends StatelessWidget {
  CancelingConfirmationBottomSheet({super.key});

  final presence = GetIt.I.get<PresencePlayers>();

  @override
  Widget build(BuildContext context) {
    final confirmedPlayers = presence.promisedSortedByName.watch(context);
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

  onChangeCanceled(HomeArrivingPlayer homeArrivingPlayer, value) {
    presence.playerCanceled(homeArrivingPlayer);
  }
}
