import 'package:equilibrium/home/presentation/arrived_players_route.dart';
import 'package:equilibrium/home/presentation/confirmed_players_route.dart';
import 'package:equilibrium/home/presentation/registered_players_route.dart';
import 'package:flutter/material.dart';

class PresenceScreen extends StatelessWidget {
  const PresenceScreen({super.key});

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
          body: const TabBarView(
            children: [
              RegisteredPlayersRoute(),
              ConfirmedPlayersRoute(),
              ArrivedPlayersRoute(),
            ],
          ),
        ),
      ),
    );
  }
}
