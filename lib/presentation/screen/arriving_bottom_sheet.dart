import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class ArrivingBottomSheet extends StatelessWidget {
  ArrivingBottomSheet({super.key});

  final presence = GetIt.I.get<PresencePlayers>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Aguardando chegada',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Expanded(
          child: Container(
            color: Colors.white10,
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: presence.arrivingSortedByName.watch(context).length,
              itemBuilder: (context, index) {
                return PlayerTile(
                  player: presence.arrivingSortedByName
                      .watch(context)[index]
                      .player,
                  arrived: presence.arrivingSortedByName
                      .watch(context)[index]
                      .hasArrived,
                  onChangeArriving: (value) => onChangeArriving(
                    presence.arrivingSortedByName.watch(context)[index].player,
                    value,
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  onChangeArriving(Player player, value) {
    presence.playerArrived(player, value);
  }
}
