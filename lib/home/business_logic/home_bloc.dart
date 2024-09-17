import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/controller_manager.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:equilibrium/presentation/model/bottom_navigation_type.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ControllerManager controllerManager;
  final PresencePlayerRepository repository;
  final Coach coach;
  final Settings settings;

  HomeBloc({
    required this.controllerManager,
    required this.repository,
    required this.coach,
    required this.settings
  }) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  late final arrivedPlayersSignals = repository.getComputedArrivedPresencePlayers();
  final Signal bottomNavAction = Signal(BottomNavigationType.home);

  //TODO: Refactorar isso para usar state ou sealed class ou named constructor.
  final Map<FABActionType, FABData> maps = {
    FABActionType.addPlayer: const FABData(BottomNavigationType.home, "Adicionar jogador", Icons.add_circle_outlined, ),
    FABActionType.balancePlayers: const FABData(BottomNavigationType.balance, "Balanciar times", Icons.balance,),
    FABActionType.gameCreation: const FABData(BottomNavigationType.game, "Criar partida", Icons.create,),
    FABActionType.gameStart: const FABData(BottomNavigationType.game, "Iniciar partida", Icons.not_started,),
    FABActionType.gameFinish: const FABData(BottomNavigationType.game, "Terminar partida", Icons.sports,),
    FABActionType.changeTeams: const FABData(BottomNavigationType.game, "Trocar times", Icons.close_fullscreen,),
  };

  late final fabData = Signal(maps[FABActionType.addPlayer]);

  final List<FABData> fabActions = [
    const FABData(
      BottomNavigationType.home,
      "Adicionar jogador",
      Icons.add,
    ),
    const FABData(
      BottomNavigationType.balance,
      "Balanciar times",
      Icons.balance,
    ),
    const FABData(
      BottomNavigationType.game,
      "Criar partida",
      Icons.create,
    ),
    const FABData(
      BottomNavigationType.game,
      "Iniciar partida",
      Icons.not_started,
    ),
    const FABData(
      BottomNavigationType.game,
      "Terminar partida",
      Icons.close_fullscreen,
    )
  ];

  @override
  Future<void> close() {
    arrivedPlayersSignals.dispose();

    return super.close();
  }
}

class FABData {
  const FABData(this.type, this.name, this.icon);

  final BottomNavigationType type;
  final String name;
  final IconData icon;
}

enum FABActionType { addPlayer, balancePlayers, gameCreation, gameStart, gameFinish, changeTeams }