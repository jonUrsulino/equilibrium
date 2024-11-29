import 'package:equilibrium/balance/presentation/balance_route.dart';
import 'package:equilibrium/domain/controller_manager.dart';
import 'package:equilibrium/game/presentation/game_route.dart';
import 'package:equilibrium/home/business_logic/home_bloc.dart';
import 'package:equilibrium/home/presentation/presence_route.dart';
import 'package:equilibrium/presentation/model/bottom_navigation_type.dart';
import 'package:equilibrium/presentation/screen/canceling_confirmation_bottom_sheet.dart';
import 'package:equilibrium/presentation/screen/new_player_dialog.dart';
import 'package:equilibrium/raffle_players/presentation/raffle_players_widget.dart';
import 'package:equilibrium/settings/presentation/settings.dart';
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
    print("home balance");
    // bloc.coach.balanceTeams();
    // bloc.coach.printTeams();
    // bloc.fabData.value = bloc.maps[FABActionType.gameStart];
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
        appBar: _buildAppBar(bloc, context),
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Watch((context) {
          switch (bloc.bottomNavAction.value) {
            case BottomNavigationType.home:
              return const PresenceRoute();
            case BottomNavigationType.balance:
              return const BalanceRoute();
            case BottomNavigationType.game:
              return const GameRoute();
            case BottomNavigationType.settings:
            default:
              return const SettingsScreen();
          }
        }),
        bottomNavigationBar: _buildBottomAppBar(bloc, context),
        floatingActionButton: _buildFAB()
    );
  }

  AppBar _buildAppBar(HomeBloc bloc, BuildContext context) {
    return AppBar(
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
        ],
      );
  }

  BottomAppBar _buildBottomAppBar(HomeBloc bloc, BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      color: Colors.cyan.shade400,
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(

            tooltip: "Jogadores",
            icon: const Icon(
              Icons.directions_run,
              color: Colors.black,
            ),
            onPressed: () => onTapBottomNavigation(bloc, BottomNavigationType.home),
          ),
          IconButton(
            tooltip: "Times",
            icon: const Icon(
              Icons.groups,
              color: Colors.black,
            ),
            onPressed: () => onTapBottomNavigation(bloc, BottomNavigationType.balance),
          ),
          IconButton(
            tooltip: "Partida",
            icon: const Icon(
              Icons.sports_soccer,
              color: Colors.black,
            ),
            onPressed: () => onTapBottomNavigation(bloc, BottomNavigationType.game),
          ),
          IconButton(
            tooltip: "Ajustes",
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () => onTapBottomNavigation(bloc, BottomNavigationType.settings),
          ),
        ],
      ),
    );
  }


  Widget _buildFAB() {
    return Watch((context) {
      final HomeBloc bloc = context.read();
      var fab = bloc.fabData.value!;
      return FloatingActionButton(
        onPressed: () => onPressed(bloc, fab),
        shape: const CircleBorder(),
        child: Icon(fab.icon),
      );
    });
  }

  void onTapBottomNavigation(HomeBloc bloc, BottomNavigationType type) {
    bloc.bottomNavAction.set(type);

    switch (type) {
      case BottomNavigationType.home:
        bloc.fabData.value = bloc.maps[FABActionType.addPlayer];
      case BottomNavigationType.balance:
        bloc.fabData.value = bloc.maps[FABActionType.balancePlayers];
      case BottomNavigationType.game:
        updateFABGameIcon(bloc);
      case BottomNavigationType.settings:
        bloc.fabData.value = bloc.maps[FABActionType.addPlayer];
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

  String _title(HomeBloc bloc, int index) {
    switch (index) {
      case 0:
        return 'Presentes:';
      case 1:
        return 'Balanciamento';
      case 2:
        return 'Partida';
      case 3:
        return 'Ajustes';
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
      case BottomNavigationType.settings:
        // do nothing.
    }
  }
}
