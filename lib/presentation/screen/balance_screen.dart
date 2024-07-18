import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class BalanceScreen extends StatelessWidget {
  static const route = "BalanceScreen";

  const BalanceScreen({
    required this.coach,
    super.key,
  });

  final Coach coach;

  @override
  Widget build(BuildContext context) {
    final teams = coach.teams.watch(context);
    return ListView.builder(
      itemCount: teams.length,
      itemBuilder: (context, index) {
        return _playerItem(context, index);
      },
    );
  }

  PlayerTile _playerItem(BuildContext context, int index) {
    final arrivedPlayers = coach.presence.arrived.watch(context);
    var player = arrivedPlayers[index].player;
    return PlayerTile(
      player: player,
      arrived: arrivedPlayers[index].hasArrived,
      onChangeArriving: (isChecked) {
        if (isChecked) {
          coach.presence.playerArrived(player, isChecked);
        } else {
          coach.presence.playerMissed(player, isChecked);
        }
      },
    );
  }
}
