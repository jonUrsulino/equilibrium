import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/use_case/get_computed_arrived_players.dart';
import 'package:equilibrium/domain/use_case/get_computed_presence_players_sorted_by_name.dart';
import 'package:equilibrium/presentation/screen/arriving_bottom_sheet.dart';
import 'package:equilibrium/presentation/screen/confirmed_bottom_sheet.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class PresenceScreen extends StatelessWidget {
  PresenceScreen({
    super.key,
  });

  final repository = GetIt.I.get<PresencePlayerRepository>();
  final getComputedPresencePlayersSortedByName = GetIt.I.get<GetComputedPresencePlayersSortedByName>();
  final getComputedArrivedPresencePlayers = GetIt.I.get<GetComputedArrivedPresencePlayers>();

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
              ConfirmedBottomSheet(),
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
                final homeArrived = getComputedArrivedPresencePlayers.execute().value;
                final length = homeArrived.length;

                return ListView.builder(
                  itemCount: length,
                  itemBuilder: (context, index) {
                    var homeArrivedPlayer = homeArrived[index];
                    return PlayerTile(
                      player: homeArrivedPlayer.player,
                      arrived: true,
                      onChangeArriving: (value) => onChangeMissing(
                        homeArrivedPlayer,
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

  onChangeMissing(PresencePlayer presencePlayer, value) {
    repository.playerMissed(presencePlayer, value);
  }
}
