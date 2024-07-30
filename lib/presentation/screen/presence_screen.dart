import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/presentation/screen/arriving_bottom_sheet.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:equilibrium/presentation/screen/promised_bottom_sheet.dart';
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
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Container(
        color: Colors.blueGrey,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Jogadores',
                ),
                Tab(
                  text: 'Confirmados',
                ),
                Tab(
                  text: 'Chegada',
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ArrivingBottomSheet(),
              PromisedBottomSheet(),
              _buildArrived(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArrived() {
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
                      arrived: true,
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

  Widget _buildPromised() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Watch(
              (context) {
                var homeArrived = presence.arrivingSortedByName.value;
                var length = homeArrived.length;

                return ListView.builder(
                  itemCount: length,
                  itemBuilder: (context, index) {
                    var homeArrivedPlayer = homeArrived[index];
                    return PlayerTile(
                      player: homeArrivedPlayer.player,
                      arrived: true,
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
}
