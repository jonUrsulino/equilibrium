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
  final bottomAction = Signal(BottomNavigationScreens.home);

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
            case BottomNavigationScreens.home:
              return PresenceScreen(presence: presence);
            case BottomNavigationScreens.balance:
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
        floatingActionButton: FloatingActionButton(
          onPressed: _addNewPlayer,
          tooltip: 'Adicionar jogador',
          child: const Icon(Icons.add),
        ));
  }

  void _addNewPlayer() {
    print("add new player");
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
    bottomAction.set(BottomNavigationScreens.home);
  }

  void goToTeams() {
    bottomAction.set(BottomNavigationScreens.balance);
  }

  void goToGame() {
    bottomAction.set(BottomNavigationScreens.game);
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
}

enum BottomNavigationScreens { home, balance, game }
