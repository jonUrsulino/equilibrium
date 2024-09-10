

import 'dart:math';

import 'package:equilibrium/domain/manager.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/domain/repository/team_repository.dart';
import 'package:equilibrium/presentation/screen/game_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';

import 'coach.dart';

class ControllerManager {
  ControllerManager();

  final Coach coach = GetIt.I.get();
  final TeamRepository teamRepository = GetIt.I.get();

  late var teams = teamRepository.getTeams();
  final nextTeams = ListSignal([]);

  late ManagerGame managerGame;
  late var teamA = signal(managerGame.teamA);
  late var teamB = signal(managerGame.teamB);

  final List<ManagerGame> history = [];
  final gameAction = signal(GameAction.creation);

  void initManagerGame() {
    print('initManagerGame');

    if (teams.length >= 2) {
      managerGame = ManagerGame(teamA: teams[0], teamB: teams[1]);
      updateTeams();

      nextTeams.clear();
      nextTeams.addAll(teams.getRange(2, teams.length));

      gameAction.value = GameAction.readyToPlay;
      // history.add(managerGame!);
    }
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

  void recreateManagerGame(Team loserTeam, SideTeam sideTeam) {
    if (nextTeams.isNotEmpty) {

      Team nextTeam = nextTeams[0];
      nextTeams.remove(nextTeam);
      nextTeams.add(loserTeam);
      dismount(loserTeam);

      managerGame.createNewGame(nextTeam, sideTeam);

      updateTeams();

      gameAction.value = GameAction.readyToPlay;
      history.add(managerGame);
    } else {
      print('Need to create New Team with next players');
    }
  }

  void dismount(Team loserTeam) {
    final Signal<Team> nextIncompleteTeamSignal = teamRepository.nextIncompleteTeam();
    var nextIncompleteTeam = nextIncompleteTeamSignal.value;

    int lengthGhosts = nextIncompleteTeam.ghostPlayersLength();

    var random = Random();
    final List<PresencePlayer> playersLoserTeam = loserTeam.players;
    final List<PresencePlayer> sortedPlayersLoserTeam = [];

    while(sortedPlayersLoserTeam.length < lengthGhosts) {
      var numberRandomized = random.nextInt(playersLoserTeam.length);

      var luckyPlayer = playersLoserTeam[numberRandomized];
      playersLoserTeam.remove(luckyPlayer);

      sortedPlayersLoserTeam.add(luckyPlayer);
      print('Lucky: ${luckyPlayer.player.name}');

      if (playersLoserTeam.isEmpty) {
        break;
      }
    }

    final List<PresencePlayer> arrivedPlayers = nextIncompleteTeam.arrivedPlayers();
    nextIncompleteTeamSignal.value.copyWith(
        shirt: nextIncompleteTeam.shirt,
        players: arrivedPlayers + sortedPlayersLoserTeam
    );
  }
}

enum GameAction {
  creation, readyToPlay, playing, finish
}