

import 'dart:math';

import 'package:equilibrium/domain/manager.dart';
import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/shirt.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/repository/team_repository.dart';
import 'package:equilibrium/game/presentation/game_card.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';

import 'coach.dart';

class ControllerManager {
  ControllerManager();

  final Coach coach = GetIt.I.get();
  final TeamRepository teamRepository = GetIt.I.get();
  final PresencePlayerRepository presencePlayerRepository = GetIt.I.get();

  late var teams = teamRepository
      .getTeams()
      .value;
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
      final Team winnerTeam;
      switch (loserSide) {
        case SideTeam.teamA:
          winnerTeam = managerGame.teamB;
        case SideTeam.teamB:
          winnerTeam = managerGame.teamA;
      }
      final nextTeamUpdated = dismountLoserTeamAndPushNextTeam(
          loserTeam, winnerTeam);
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

  Team dismountLoserTeamAndPushNextTeam(Team loserTeam, Team winnerTeam) {
    int index = nextTeams.indexWhere((element) =>
    element
        .notArrivedPlayers(presencePlayerRepository)
        .isNotEmpty);
    print('index team with ghosts $index');

    if (_doNotHaveGhosts(index)) {
      print("all teams are full with arrived players");
      return _commitChangeQueueTeams(loserTeam);
    }

    if (coach.settings.isEnabledBalanceInChangeOfTeams()) {
      loserTeam = _balancePlayersLoserTeamSendingToLastTeam(
          index, loserTeam, winnerTeam);
    } else {
      loserTeam = _rafflePlayersLoserTeamSendingToLastTeam(index, loserTeam);
    }

    return _commitChangeQueueTeams(loserTeam);
  }

  bool _doNotHaveGhosts(int index) => index < 0;

  Team _commitChangeQueueTeams(Team loserTeam) {
    nextTeams.add(loserTeam);
    var first = nextTeams.first;
    nextTeams.removeAt(0);
    return first;
  }

  List<Player> getNotArrivedPlayers(Team incompleteTeam) {
    final List<Player> notArrivedPlayers = incompleteTeam
        .notArrivedPlayers(presencePlayerRepository)
        .map((e) => e.player)
        .toList();
    return notArrivedPlayers;
  }

  Team rearrangeTeamWith(Team loserTeam, List<Player> playersLoserTeam,
      List<Player> notArrivedPlayers) {
    loserTeam = loserTeam.copyWith(
      shirt: loserTeam.shirt,
      players: playersLoserTeam + notArrivedPlayers,
    );
    return loserTeam;
  }

  Team rearrangeIncompleteTeamWithSelectedPlayersBalanceOrRaffled(
      Team incompleteTeam, List<Player> sortedPlayersLoserTeam) {
    final List<Player> arrivedPlayers = incompleteTeam
        .arrivedPlayers(presencePlayerRepository)
        .map((e) => e.player)
        .toList();

    incompleteTeam = rearrangeTeamWith(
        incompleteTeam, arrivedPlayers, sortedPlayersLoserTeam);

    print('team incomplete adjusted ${incompleteTeam.shirt.name}');
    for (var i in incompleteTeam.players) {
      print('player incomplete adjusted ${i.name}');
    }
    return incompleteTeam;
  }

  Team _rafflePlayersLoserTeamSendingToLastTeam(int index, Team loserTeam) {
    Team incompleteTeam = nextTeams[index];
    print('not arrived team $incompleteTeam');

    List<Player> notArrivedPlayers = getNotArrivedPlayers(incompleteTeam);

    int lengthGhosts = notArrivedPlayers.length;

    for (Player p in notArrivedPlayers) {
      print("not arrived player: $p");
    }

    var random = Random();

    final List<Player> playersLoserTeam = loserTeam.players;
    final List<Player> sortedPlayersLoserTeam = List.empty(growable: true);

    print('initial sorted ${sortedPlayersLoserTeam.length}');
    print('initial ghosts $lengthGhosts');
    while (sortedPlayersLoserTeam.length < lengthGhosts) {
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

    nextTeams[index] =
        rearrangeIncompleteTeamWithSelectedPlayersBalanceOrRaffled(
            incompleteTeam, sortedPlayersLoserTeam);
    return rearrangeTeamWith(loserTeam, playersLoserTeam, notArrivedPlayers);
  }

  Team _balancePlayersLoserTeamSendingToLastTeam(int index, Team loserTeam,
      Team winnerTeam) {
    print("_balancePlayersLoserTeamSendingToLastTeam");
    // referenceWinner with StarsByPlayer
    var referenceWinner = winnerTeam.calculatePowerByPlayers();

    Team incompleteTeam = nextTeams[index];
    print('not arrived team $incompleteTeam');

    final List<Player> arrivedPlayers = incompleteTeam
        .arrivedPlayers(presencePlayerRepository)
        .map((e) => e.player)
        .toList();

    List<Player> notArrivedPlayers = getNotArrivedPlayers(incompleteTeam);

    int lengthGhosts = notArrivedPlayers.length;

    for (Player p in notArrivedPlayers) {
      print("not arrived player: $p");
    }

    final List<Player> playersLoserTeamSortedByStars = loserTeam.players
      ..sort((a, b) => b.stars.compareTo(a.stars));

    for (Player p in playersLoserTeamSortedByStars) {
      print("loser player: $p");
    }

    final List<Player> newNextTeam = arrivedPlayers.toList();
    incompleteTeam.players.clear();
    final Team nextTeam = incompleteTeam;
    nextTeam.players.addAll(newNextTeam);

    print('initial new next team to complete: ${newNextTeam.length}');
    print('initial ghosts $lengthGhosts');

    // for loop to complete new team
    final maxPlayersByTeamSettings = coach.settings.getMaxPlayersByTeam();
    while (nextTeam.players.length < maxPlayersByTeamSettings) {
      print('while ${nextTeam.players.length} < $maxPlayersByTeamSettings');

      // calc current starsByPlayer
      var nextTeamStrength = nextTeam.calculatePowerByPlayers();

      // compare with referenceWinner
      Player luckyPlayer;
      // if equal with tolerance then get middle strength
      var diffStrength = nextTeamStrength - referenceWinner;
      print("winner: $referenceWinner nextTeam: $nextTeamStrength diff: $diffStrength");

      if (diffStrength >= -0.05 && diffStrength <= 0.05) {
        print("strength equal: $diffStrength");
        final int middle = playersLoserTeamSortedByStars.length ~/ 2;
        luckyPlayer = playersLoserTeamSortedByStars[middle];

      } else if (nextTeamStrength > referenceWinner) {
        print("nextTeamStrength is stronger"); //then get weak player
        luckyPlayer = playersLoserTeamSortedByStars.last;

      } else {
        print("nextTeamStrength is weaker"); //then get strong player
        luckyPlayer = playersLoserTeamSortedByStars.first;
      }
      playersLoserTeamSortedByStars.remove(luckyPlayer);

      nextTeam.players.add(luckyPlayer);
      print('Lucky: ${luckyPlayer.name}');

      if (playersLoserTeamSortedByStars.isEmpty) {
        break;
      }
    }

    // remove this player of loserTeam
    // add this to nextTeam
    nextTeams[index] = nextTeam;
    return rearrangeTeamWith(
        loserTeam, playersLoserTeamSortedByStars, notArrivedPlayers);
  }
}

enum GameAction {
  creation, readyToPlay, playing, finish
}