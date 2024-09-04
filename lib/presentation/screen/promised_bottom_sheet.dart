import 'package:equilibrium/domain/home_arriving_player.dart';
import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class PromisedBottomSheet extends StatelessWidget {
  PromisedBottomSheet({super.key});

  final presence = GetIt.I.get<PresencePlayers>();

  @override
  Widget build(BuildContext context) {
    final confirmedPlayersList = presence.promisedSortedByName.watch(context);
    return Column(
      children: [
        Text(
          'Confirme quem já chegou. Confirmados: ${confirmedPlayersList.length}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: confirmedPlayersList.length,
            itemBuilder: (context, index) {
              var homeArrivingPlayer =
                  confirmedPlayersList[index];
              return PlayerTile(
                  player: homeArrivingPlayer.player,
                  arrived: false,
                  onChangeArriving: (value) => onChangeArriving(
                    homeArrivingPlayer,
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

  onChangeArriving(HomeArrivingPlayer homeArrivingPlayer, value) {
    presence.playerArrived(homeArrivingPlayer, value);
  }

  onChangeCanceled(HomeArrivingPlayer homeArrivingPlayer) {
    presence.playerCanceled(homeArrivingPlayer);
  }
}
