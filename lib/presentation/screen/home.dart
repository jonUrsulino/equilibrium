import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SignalsAutoDisposeMixin {
  final presence = PresencePlayers();

  void balance() {
    var coach = Coach(presence);
    coach.balanceTeams();
    coach.printTeams();
  }

  @override
  void initState() {
    presence.effecting;
    balance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Watch((context) {
            return Text(
              presence.lastName.value,
              style: Theme.of(context).textTheme.headlineLarge,
            );
          }),
          actions: [
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.settings),
            )
          ],
        ),
        body: Column(
          children: [
            Watch(
              (context) {
                return Text(
                  'Jogadores presentes: ${presence.arrived.length}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
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
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              label: "Jogadores",
              icon: Icon(Icons.group),
            ),
            BottomNavigationBarItem(
              label: "Times",
              icon: Icon(Icons.balance),
            ),
            BottomNavigationBarItem(
              label: "Partida",
              icon: Icon(Icons.sports_soccer),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNewPlayer,
          tooltip: 'Adicionar jogador',
          child: const Icon(Icons.add),
        ));
  }

  void _addNewPlayer() {
    print("add new player");
  }

  onChangeArriving(Player player, value) {
    presence.playerArrived(player, value);
  }

  onChangeMissing(Player player, value) {
    presence.playerMissed(player, value);
  }
}
