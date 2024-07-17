import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class PresenceScreen extends StatelessWidget {
  const PresenceScreen({
    required this.presence,
    super.key,
  });

  final PresencePlayers presence;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Watch(
            (context) {
              var homeArrived = presence.arrived.value;
              var length = homeArrived.length;

              return ListView.builder(
                itemCount: length,
                itemBuilder: (context, index) {
                  var homeArrivedPlayer = homeArrived[index];
                  return PlayerTile(
                    player: homeArrivedPlayer.player,
                    arrived: homeArrivedPlayer.hasArrived,
                    onChangeArriving: (value) => onChangeMissing(
                      homeArrivedPlayer.player,
                      value,
                    ),
                  );
                },
              );
            },
          ),
        ),
        Text(
          'Aguardando chegada',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Expanded(
          child: Container(
            color: Colors.white30,
            child: Watch(
              (context) {
                var homeArriving = presence.arriving.value;
                var length = homeArriving.length;

                return ListView.builder(
                  itemCount: length,
                  itemBuilder: (context, index) {
                    var homeArrivingPlayer = homeArriving[index];
                    return PlayerTile(
                      player: homeArrivingPlayer.player,
                      arrived: homeArrivingPlayer.hasArrived,
                      onChangeArriving: (value) => onChangeArriving(
                        homeArrivingPlayer.player,
                        value,
                      ),
                    );
                  },
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

  onChangeMissing(Player player, value) {
    presence.playerMissed(player, value);
  }
}
