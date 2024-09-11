

import 'dart:math';

import 'package:equilibrium/domain/manager.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
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
  late final nextTeams = teamRepository.getNextTeams().value;

  late ManagerGame managerGame = ManagerGame(teamA: teams[0], teamB: teams[1]);
  late Team teamA = managerGame.teamA;
  late Team teamB = managerGame.teamB;

  final List<ManagerGame> history = [];
  final gameAction = signal(GameAction.creation);

  void initManagerGame() {
    print('initManagerGame');

    if (teams.length >= 2) {
      updateTeams();

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

  void updateTeams() {
    teamA = managerGame.teamA;
    teamB = managerGame.teamB;
  }

  void startGame() {
    managerGame.startGame();
    gameAction.value = GameAction.playing;
  }

  void finishGame() {
    managerGame.finishGame();
    gameAction.value = GameAction.finish;
  }

  void recreateManagerGame(Team loserTeam, SideTeam loserSide) {
    print("recreateManagerGame");
    if (nextTeams.isNotEmpty) {
      Team nextTeam = nextTeams[0];

      var goToField = dismount(loserTeam, nextTeam);
      nextTeams.remove(goToField);

      updateTeams();
      managerGame.createNewGame(nextTeam, loserSide);

      List<Team> gameChange;
      switch (loserSide) {
        case SideTeam.teamA:
          gameChange = [
            nextTeam,
            managerGame.teamB,
          ];
        case SideTeam.teamB:
          gameChange = [
            managerGame.teamA,
            nextTeam,
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

  Team dismount(Team loserTeam, Team nextTeam) {
    for (Team item in nextTeams) {
      print('incomplete? ${item.shirt.name} ${item.incomplete}');
    }

    int index = nextTeams.indexWhere((element) => element.notArrivedPlayers(presencePlayerRepository).isNotEmpty);
    print('initial index $index');

    if (index < 0) {
      print("all teams are complete with arrived players");
      var first = nextTeams.first;

      return first;
    }

    Team incompleteTeam = nextTeams[index];
    print('not arrived team $incompleteTeam');

    final List<PresencePlayer> notArrivedPlayers = incompleteTeam.notArrivedPlayers(presencePlayerRepository);
    int lengthGhosts = notArrivedPlayers.length;

    for (PresencePlayer p in notArrivedPlayers) {
      print("not arrived player: ${p}");
    }

    var random = Random();

    final List<PresencePlayer> playersLoserTeam = loserTeam.actualPresencePlayers(presencePlayerRepository);
    final List<PresencePlayer> sortedPlayersLoserTeam = List.empty(growable: true);

    print('initial sorted ${sortedPlayersLoserTeam.length}');
    print('initial ghosts $lengthGhosts');
    while(sortedPlayersLoserTeam.length < lengthGhosts) {
      print('while ${sortedPlayersLoserTeam.length} < $lengthGhosts');
      var numberRandomized = random.nextInt(playersLoserTeam.length);

      var luckyPlayer = playersLoserTeam[numberRandomized];
      playersLoserTeam.remove(luckyPlayer);

      sortedPlayersLoserTeam.add(luckyPlayer);
      print('Lucky: ${luckyPlayer.player.name}');

      if (playersLoserTeam.isEmpty) {
        break;
      }
    }

    // TODO presencePlayerRepository.getPresencePlayersByNames();
    final List<PresencePlayer> arrivedPlayers = incompleteTeam.arrivedPlayers(presencePlayerRepository);

    incompleteTeam = incompleteTeam.copyWith(
        shirt: incompleteTeam.shirt,
        presencePlayers: arrivedPlayers + sortedPlayersLoserTeam,
        players: arrivedPlayers.map((e) => e.player).toList() + sortedPlayersLoserTeam.map((e) => e.player).toList(),
    );
    print('team incomplete adjusted ${incompleteTeam.shirt.name}');
    for (var i in incompleteTeam.players) {
      print('player incomplete adjusted ${i.name}');
    }
    loserTeam = loserTeam.copyWith(
        shirt: loserTeam.shirt,
        presencePlayers: playersLoserTeam + notArrivedPlayers,
        players: playersLoserTeam.map((e) => e.player).toList() + notArrivedPlayers.map((e) => e.player).toList(),
    );
    nextTeams[index] = incompleteTeam;
    nextTeams.add(loserTeam);
    return nextTeam;
  }
}

enum GameAction {
  creation, readyToPlay, playing, finish
}