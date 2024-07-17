import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class BalanceScreen extends StatelessWidget {
  static const route = "BalanceScreen";

  const BalanceScreen({
    required this.presence,
    super.key,
  });

  final PresencePlayers presence;

  @override
  Widget build(BuildContext context) {
    final arrivedPlayers = presence.arrived.watch(context);
    return ListView.builder(
      itemCount: arrivedPlayers.length,
      itemBuilder: (context, index) {
        var player = arrivedPlayers[index].player;
        return PlayerTile(
          player: player,
          arrived: arrivedPlayers[index].hasArrived,
          onChangeArriving: (isChecked) {
            if (isChecked) {
              presence.playerArrived(player, isChecked);
            } else {
              presence.playerMissed(player, isChecked);
            }
          },
        );
      },
    );
  }
}
