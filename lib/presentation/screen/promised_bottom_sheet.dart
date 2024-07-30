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
    return Column(
      children: [
        Text(
          'Confirme quem já chegou',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: presence.promisedSortedByName.watch(context).length,
            itemBuilder: (context, index) {
              var homeArrivingPlayer =
                  presence.promisedSortedByName.watch(context)[index];
              return Dismissible(
                background: Container(color: Colors.deepOrange),
                onDismissed: (direction) {
                  onChangeCanceled(homeArrivingPlayer);
                },
                key: Key(homeArrivingPlayer.player.name),
                child: PlayerTile(
                  player: homeArrivingPlayer.player,
                  arrived: false,
                  onChangeArriving: (value) => onChangeArriving(
                    homeArrivingPlayer,
                    value,
                  ),
                  showStars: true,
                ),
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
