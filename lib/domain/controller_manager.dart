

import 'package:equilibrium/domain/manager.dart';
import 'package:equilibrium/domain/team.dart';
import 'package:equilibrium/presentation/screen/game_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';

import 'coach.dart';

class ControllerManager {
  ControllerManager();

  final Coach coach = GetIt.I.get();
  final nextTeams = ListSignal([]);

  late ManagerGame managerGame;
  late var teamA = signal(managerGame.teamA);
  late var teamB = signal(managerGame.teamB);

  final List<ManagerGame> history = [];
  final gameAction = signal(GameAction.creation);

  void initManagerGame() {
    print('initManagerGame');
    var teams = coach.teams.value;
    managerGame = ManagerGame(teamA: teams[0], teamB: teams[1]);
    updateTeams();

    nextTeams.clear();
    for (var i = 2; i < teams.length; i++) {
      nextTeams.add(teams[i]);
    }

    gameAction.value = GameAction.readyToPlay;
    // history.add(managerGame!);
  }

  void updateTeams() {
    teamA.value = managerGame.teamA;
    teamB.value = managerGame.teamB;
  }

  void startGame() {
    managerGame.startGame();
    gameAction.value = GameAction.playing;
  }

  void finishGame() {
    managerGame.finishGame();
    gameAction.value = GameAction.finish;
  }

  void changeTeam(Team loserTeam, SideTeam sideTeam) {
    recreateManagerGame(loserTeam, sideTeam);
  }

  void recreateManagerGame(Team loserTeam, SideTeam sideTeam) {
      if (nextTeams.isNotEmpty) {
        Team nextTeam = nextTeams[0];
        nextTeams.remove(nextTeam);
        nextTeams.add(loserTeam);

        managerGame.createNewGame(nextTeam, sideTeam);

        updateTeams();

        gameAction.value = GameAction.readyToPlay;
        history.add(managerGame);
      } else {
        print('Need to create New Team with next players');
      }
  }
}

enum GameAction {
  creation, readyToPlay, playing, finish
}