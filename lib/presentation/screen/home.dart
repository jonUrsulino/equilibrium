import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Player> players = [
    Player("Jonathan", 4.0),
    Player("Tiago", 5.0),
    Player("Bino", 1.0),
    Player("Danilo", 3.0),
    Player("Edmilson", 2.0),
    Player("Matias", 2.0),
    Player("Pr. Silvano", 1.0),
    Player("Kennedy", 4.0),
    Player("Carlos", 3.0),
    Player("Goleiro", 5.0),
    Player("Fabão", 3.0),
    Player("Fabinho", 2.0),
    Player("Motoca", 5.0),
    Player("Mike", 3.0),
    Player("Fi do Dimas", 3.0),
    Player("Davi", 3.0),
    Player("Adriano", 3.0),
  ];

  void balance() {
    var coach = Coach(PresencePlayers());
    coach.balanceTeams();
    coach.printTeams();
  }

  @override
  void initState() {
    balance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Equilibrium"),
        ),
        body: ListView.builder(
          itemCount: players.length,
          itemBuilder: (context, index) {
            return PlayerTile(player: players[index]);
          },
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
}
