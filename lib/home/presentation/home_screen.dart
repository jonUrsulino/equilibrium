import 'package:equilibrium/balance/presentation/balance_route.dart';
import 'package:equilibrium/domain/controller_manager.dart';
import 'package:equilibrium/game/presentation/game_route.dart';
import 'package:equilibrium/home/business_logic/home_bloc.dart';
import 'package:equilibrium/home/presentation/presence_route.dart';
import 'package:equilibrium/navigator/nav_extensions.dart';
import 'package:equilibrium/presentation/screen/canceling_confirmation_bottom_sheet.dart';
import 'package:equilibrium/game/presentation/game_screen.dart';
import 'package:equilibrium/presentation/screen/new_player_dialog.dart';
import 'package:equilibrium/presentation/screen/settings.dart';
import 'package:equilibrium/raffle_players/presentation/raffle_players_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void balance(HomeBloc bloc) {
    bloc.coach.balanceTeams();
    bloc.coach.printTeams();
    // bloc.controllerManager.initManagerGame();
    bloc.fabData.value = bloc.maps[FABActionType.gameStart];
  }

  void actionManagerGame(HomeBloc bloc) {
    var gameAction = bloc.controllerManager.gameAction.watch(context);
    switch (gameAction) {
      case GameAction.creation:
        bloc.controllerManager.initManagerGame();
      case GameAction.readyToPlay:
        bloc.controllerManager.startGame();
      case GameAction.playing:
        bloc.controllerManager.finishGame();
      case GameAction.finish:
      // controllerManager.changeTeam();
      default:
    }
  }

  void updateFABGameIcon(HomeBloc bloc) {
    var gameAction = bloc.controllerManager.gameAction.watch(context);
    switch (gameAction) {
      case GameAction.creation:
        bloc.fabData.value = bloc.maps[FABActionType.gameCreation];
      case GameAction.readyToPlay:
        bloc.fabData.value = bloc.maps[FABActionType.gameStart];
      case GameAction.playing:
        bloc.fabData.value = bloc.maps[FABActionType.gameFinish];
      case GameAction.finish:
        bloc.fabData.value = bloc.maps[FABActionType.changeTeams];
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final HomeBloc bloc = context.read();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            _title(bloc, bloc.bottomNavAction.watch(context).index),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          actions: [
            IconButton(
              onPressed: () => _onTapVisibleButtons(bloc),
              icon: Icon(bloc.settings.starsVisible.watch(context)
                  ? Icons.visibility
                  : Icons.visibility_off),
            ),
            IconButton(
              onPressed: () => _onTapSortPlayers(),
              icon: const Icon(Icons.published_with_changes),
            ),
            IconButton(
              onPressed: () => _onTapCheckPresence(),
              icon: const Icon(Icons.check),
            ),
            IconButton(
              onPressed: () => _onTapSettings(),
              icon: const Icon(Icons.settings),
            )
          ],
        ),
        body: Watch((context) {
          switch (bloc.bottomNavAction.value) {
            case BottomNavigationType.home:
              return const PresenceRoute();
            case BottomNavigationType.balance:
              return const BalanceRoute();
            case BottomNavigationType.game:
            default:
              return const GameRoute();
          }
        }),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          enableFeedback: true,
          currentIndex: bloc.bottomNavAction.watch(context).index,
          onTap: (value) {
            return onTapBottomNavigation(bloc, value);
          },
          items: const [
            BottomNavigationBarItem(
              label: "Jogadores",
              icon: Icon(Icons.directions_run),
            ),
            BottomNavigationBarItem(
              label: "Times",
              icon: Icon(Icons.groups),
            ),
            BottomNavigationBarItem(
              label: "Partida",
              icon: Icon(Icons.sports_soccer),
            ),
          ],
        ),
        floatingActionButton: _buildFAB());
  }

  Widget _buildFAB() {
    return Watch((context) {
      final HomeBloc bloc = context.read();
      var fab = bloc.fabData.value!;
      return FloatingActionButton(
        onPressed: () => onPressed(bloc, fab),
        tooltip: fab.name,
        child: Icon(fab.icon),
      );
    });
  }

  void onTapBottomNavigation(HomeBloc bloc, int value) {
    switch (value) {
      case 0:
        bloc.bottomNavAction.set(BottomNavigationType.home);
        bloc.fabData.value = bloc.maps[FABActionType.addPlayer];
      case 1:
        bloc.bottomNavAction.set(BottomNavigationType.balance);
        bloc.fabData.value = bloc.maps[FABActionType.balancePlayers];
      case 2:
        bloc.bottomNavAction.set(BottomNavigationType.game);
        updateFABGameIcon(bloc);
      default:
        bloc.bottomNavAction.set(BottomNavigationType.home);
    }
  }

  void _onTapVisibleButtons(HomeBloc bloc) {
    print('visible');

    bloc.settings.toggleStarsVisible();
  }

  void _onTapSortPlayers() {
    print('presence');
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return const RafflePlayersWidget();
      },
    );
  }

  void _onTapCheckPresence() {
    print('presence');
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return CancelingConfirmationBottomSheet(
          repository: GetIt.I.get(),
        );
      },
    );
  }

  void _onTapSettings() {
    print('settings');
    context.navigator.navigateToScreen(name: SettingsScreen.route);
  }

  String _title(HomeBloc bloc, int index) {
    switch (index) {
      case 0:
        return 'Presentes: ${bloc.arrivedPlayersSignals.watch(context).length}';
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

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const NewPlayerDialog();
      },
    );
  }

  void onPressed(HomeBloc bloc, FABData fab) {
    print('onPressed fab ${fab.name}');
    switch (fab.type) {
      case BottomNavigationType.home:
        _addPlayers();
      case BottomNavigationType.balance:
        balance(bloc);
      case BottomNavigationType.game:
        actionManagerGame(bloc);
        updateFABGameIcon(bloc);
    }
  }
}
