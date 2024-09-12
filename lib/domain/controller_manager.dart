

import 'dart:math';

import 'package:equilibrium/domain/manager.dart';
import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/repository/team_repository.dart';
import 'package:equilibrium/game/presentation/game_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';

import 'coach.dart';

class ControllerManager {
  ControllerManager();

  final Coach coach = GetIt.I.get();
  final TeamRepository teamRepository = GetIt.I.get();
  final PresencePlayerRepository presencePlayerRepository = GetIt.I.get();

  late var teams = teamRepository.getTeams().value;
  late List<Team> nextTeams = teamRepository.getNextTeams();

  late ManagerGame managerGame = ManagerGame(teamA: teams[0], teamB: teams[1]);

  final List<ManagerGame> history = [];
  final gameAction = signal(GameAction.creation);

  void initManagerGame() {
    print('initManagerGame');

    if (teams.length >= 2) {
      nextTeams = teamRepository.getNextTeams();
      gameAction.value = GameAction.readyToPlay;
      // history.add(managerGame!);
    }

    effect(() {
      for (var element in nextTeams) {
        print("changing nextTeams ${element.shirt.name}");
      }
    });
    effect(() {
      for (var element in teams) {
        print("changing teams ${element.shirt.name}");
      }
    });
  }

  void startGame() {
    managerGame.startGame();
    // gameAction.value = GameAction.playing;
  }

  void finishGame() {
    managerGame.finishGame();
    // gameAction.value = GameAction.finish;
  }

  void recreateManagerGame(Team loserTeam, SideTeam loserSide) {
    print("recreateManagerGame");
    if (nextTeams.isNotEmpty) {

      final nextTeamUpdated = dismountLoserTeamAndPushNextTeam(loserTeam);
      print("Next team: ${nextTeamUpdated.shirt.name}");
      for (Player p in nextTeamUpdated.players) {
        print("Player next team: $p");
      }

      managerGame.createNewGame(nextTeamUpdated, loserSide);

      List<Team> gameChange;
      switch (loserSide) {
        case SideTeam.teamA:
          gameChange = [
            nextTeamUpdated,
            managerGame.teamB,
          ];
        case SideTeam.teamB:
          gameChange = [
            managerGame.teamA,
            nextTeamUpdated,
          ];
      }
      final List<Team> newOrder = gameChange + nextTeams;
      teamRepository.changeOrder(newOrder);

      gameAction.value = GameAction.readyToPlay;
      history.add(managerGame);
    } else {
      print('Need to create New Team with next players');
    }
  }

  Team dismountLoserTeamAndPushNextTeam(Team loserTeam) {
    int index = nextTeams.indexWhere((element) => element.notArrivedPlayers(presencePlayerRepository).isNotEmpty);
    print('index team with ghosts $index');

    if (_doNotHaveGhosts(index)) {
      print("all teams are full with arrived players");
      return _commitChangeQueueTeams(loserTeam);
    }

    loserTeam = _rafflePlayersLoserTeamSendingToLastTeam(index, loserTeam);

    return _commitChangeQueueTeams(loserTeam);
  }

  bool _doNotHaveGhosts(int index) => index < 0;

  Team _rafflePlayersLoserTeamSendingToLastTeam(int index, Team loserTeam) {
    Team incompleteTeam = nextTeams[index];
    print('not arrived team $incompleteTeam');

    final List<Player> notArrivedPlayers = incompleteTeam
        .notArrivedPlayers(presencePlayerRepository)
        .map((e) => e.player)
        .toList();

    int lengthGhosts = notArrivedPlayers.length;

    for (Player p in notArrivedPlayers) {
      print("not arrived player: $p");
    }

    var random = Random();

    final List<Player> playersLoserTeam = loserTeam.players;
    final List<Player> sortedPlayersLoserTeam = List.empty(growable: true);

    print('initial sorted ${sortedPlayersLoserTeam.length}');
    print('initial ghosts $lengthGhosts');
    while(sortedPlayersLoserTeam.length < lengthGhosts) {
      print('while ${sortedPlayersLoserTeam.length} < $lengthGhosts');
      var numberRandomized = random.nextInt(playersLoserTeam.length);
      print('random $numberRandomized');

      var luckyPlayer = playersLoserTeam[numberRandomized];
      playersLoserTeam.remove(luckyPlayer);

      sortedPlayersLoserTeam.add(luckyPlayer);
      print('Lucky: ${luckyPlayer.name}');

      if (playersLoserTeam.isEmpty) {
        break;
      }
    }

    final List<Player> arrivedPlayers = incompleteTeam
        .arrivedPlayers(presencePlayerRepository)
        .map((e) => e.player)
        .toList();

    incompleteTeam = incompleteTeam.copyWith(
        shirt: incompleteTeam.shirt,
        players: arrivedPlayers + sortedPlayersLoserTeam,
    );
    print('team incomplete adjusted ${incompleteTeam.shirt.name}');
    for (var i in incompleteTeam.players) {
      print('player incomplete adjusted ${i.name}');
    }
    loserTeam = loserTeam.copyWith(
        shirt: loserTeam.shirt,
        players: playersLoserTeam + notArrivedPlayers,
    );
    nextTeams[index] = incompleteTeam;
    return loserTeam;
  }

  Team _commitChangeQueueTeams(Team loserTeam) {
    nextTeams.add(loserTeam);
    var first = nextTeams.first;
    nextTeams.removeAt(0);
    return first;
  }
}

enum GameAction {
  creation, readyToPlay, playing, finish
}