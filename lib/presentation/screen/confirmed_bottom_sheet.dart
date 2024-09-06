import 'package:equilibrium/domain/presence_player.dart';
import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class ConfirmedBottomSheet extends StatelessWidget {
  ConfirmedBottomSheet({super.key});

  final presence = GetIt.I.get<PresencePlayers>();

  @override
  Widget build(BuildContext context) {
    final confirmedPlayersList = presence.confirmedSortedByName.watch(context);
    return Column(
      children: [
        Text(
          'Confirme quem já chegou',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: confirmedPlayersList.length,
            itemBuilder: (context, index) {
              var presencePlayer = confirmedPlayersList[index];
              return PlayerTile(
                  player: presencePlayer.player,
                  arrived: false,
                  onChangeArriving: (value) => onChangeArriving(
                    presencePlayer,
                    value,
                  ),
                  showStars: true,
              );
            },
          ),
        )
      ],
    );
  }

  onChangeArriving(PresencePlayer presencePlayer, value) {
    presence.playerArrived(presencePlayer, value);
  }

  onChangeCanceled(PresencePlayer presencePlayer) {
    presence.playerCanceled(presencePlayer);
  }
}
