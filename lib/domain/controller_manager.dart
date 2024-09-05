

import 'package:equilibrium/domain/manager.dart';
import 'package:equilibrium/domain/team.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';

import 'coach.dart';

class ControllerManager {
  ControllerManager();

  final Coach coach = GetIt.I.get();

  ManagerGame? managerGame;
  ListSignal<Team> nextTeams = ListSignal([]);

  final List<ManagerGame> history = [];
  final gameAction = signal(GameAction.creation);

  void initManagerGame() {
    if (history.isEmpty) {
      print('First Game');
      var teams = coach.teams.value;
      managerGame = ManagerGame(teamA: teams[0], teamB: teams[1]);

      for (var i = 2; i < teams.length; i++) {
        nextTeams.add(teams[i]);
      }

      gameAction.value = GameAction.readyToPlay;
      history.add(managerGame!);
    } else {

      print('Need to be handled when NOT FIRST GAME');
    }
  }

  void startGame() {
    managerGame?.startGame();
    gameAction.value = GameAction.playing;
  }

  void finishGame() {
    managerGame?.finishGame();
    gameAction.value = GameAction.finish;
  }

  void nextGame() {
    initManagerGame();
  }
}

enum GameAction {
  creation, readyToPlay, playing, finish
}