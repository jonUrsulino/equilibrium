import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/player.dart';
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
          var team = teams[index];
          return Column(
            children: [
              ColoredBox(
                color: team.shirt.color,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    team.shirt.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  ),
                ),
              ),
              Container(
                color: team.shirt.color,
              ),
            ],
          );
          // return Column(children: [
          //   Text(team.shirt.name),
          //   ListView.builder(
          //     itemCount: team.players.length,
          //     itemBuilder: (context, index) {
          //       var player = team.players[index];
          //       return _playerItem(player);
          //     },
          //   ),
          // ]);
        });
  }

  PlayerTile _playerItem(Player player) {
    return PlayerTile(
      player: player,
      arrived: true,
      onChangeArriving: (isChecked) {
        print('Faz nada');
      },
    );
  }
}
