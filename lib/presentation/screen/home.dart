import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/presentation/screen/balance_screen.dart';
import 'package:equilibrium/presentation/screen/presence_screen.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class HomeScreen extends StatefulWidget {
  static const route = "HomeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SignalsAutoDisposeMixin {
  final presence = PresencePlayers();
  final bottomAction = Signal(BottomNavigationType.home);
  final List<FABData> fabActions = [
    const FABData(
      BottomNavigationType.home,
      "Adicionar jogador",
      Icons.add,
    ),
    const FABData(
      BottomNavigationType.balance,
      "Balanciar times",
      Icons.run_circle,
    )
  ];

  void balance() {
    var coach = Coach(presence);
    coach.balanceTeams();
    coach.printTeams();
  }

  @override
  void initState() {
    presence.effecting;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            _title(bottomAction.watch(context).index),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          actions: [
            IconButton(
              onPressed: () => _onTapSettings(),
              icon: const Icon(Icons.settings),
            )
          ],
        ),
        body: Watch((context) {
          switch (bottomAction.value) {
            case BottomNavigationType.home:
              return PresenceScreen(presence: presence);
            case BottomNavigationType.balance:
              return BalanceScreen(presence: presence);
            default:
              return Text('Sei não');
          }
        }),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          enableFeedback: true,
          currentIndex: bottomAction.watch(context).index,
          onTap: (value) {
            return onTapBottomNavigation(value);
          },
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
        floatingActionButton: _buildFAB());
  }

  FloatingActionButton _buildFAB() {
    var fab = fabActions
        .singleWhere((element) => element.type == bottomAction.watch(context));

    return FloatingActionButton(
      onPressed: () => onPressed(fab),
      tooltip: fab.name,
      child: Icon(fab.icon),
    );
  }

  void onTapBottomNavigation(int value) {
    switch (value) {
      case 0:
        goToHome();
      case 1:
        goToTeams();
      case 2:
        goToGame();
      default:
        goToHome();
    }
  }

  void goToHome() {
    bottomAction.set(BottomNavigationType.home);
  }

  void goToTeams() {
    bottomAction.set(BottomNavigationType.balance);
  }

  void goToGame() {
    bottomAction.set(BottomNavigationType.game);
    // context.navigator.navigateToScreen(name: "/game");
  }

  void _onTapSettings() {
    print('Tap on Setings');
  }

  String _title(int index) {
    switch (index) {
      case 0:
        return 'Presentes: ${presence.arrived.watch(context).length}';
      case 1:
        return 'Balanciamento';
      case 2:
        return 'Partida';
      default:
        return 'Equilibrium';
    }
  }

  void _addPlayers() {
    print("add new player");
  }

  void onPressed(FABData fab) {
    switch (fab.type) {
      case BottomNavigationType.home:
        _addPlayers();
      case BottomNavigationType.balance:
        balance();
      default:
        _addPlayers();
    }
  }
}

enum BottomNavigationType { home, balance, game }

class FABData {
  const FABData(this.type, this.name, this.icon);

  final BottomNavigationType type;
  final String name;
  final IconData icon;
}
