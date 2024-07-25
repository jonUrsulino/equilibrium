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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Watch(
              (context) {
                var homeArrived = presence.getArrivedWith(true).value;
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
                      showStars: true,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  onChangeMissing(Player player, value) {
    presence.playerMissed(player, value);
  }
}
