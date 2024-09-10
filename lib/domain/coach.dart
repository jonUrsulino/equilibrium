import 'dart:math';

import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/model/shirt.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/repository/team_repository.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';

//TODO: put it in the settings to edit colors and names of teams.
final List<Shirt> availableShirts = [
  Shirt.black(),
  Shirt.orange(),
  Shirt.blue(),
  Shirt.green(),
  Shirt.white(),
];

class Coach {
  Coach();

  final PresencePlayerRepository presencePlayerRepository = GetIt.I.get();
  final Settings settings = GetIt.I.get<Settings>();
  final TeamRepository teamRepository = GetIt.I.get();

  final List<Team> teams = [];

  void balanceTeams() {
    teams.clear();
    final maxPlayersByTeam = settings.getMaxPlayersByTeam();

    final balanceGoalkeeper = settings.isConsideredBalanceWithGoalkeeper();
    var arrivingPlayers = presencePlayerRepository.getComputedArrivedPresencePlayers().value;
    if (!balanceGoalkeeper) {
      arrivingPlayers = presencePlayerRepository.getComputedArrivedPresencePlayersWithoutGoalkeepers().value;
    }
    int amountPlayers = arrivingPlayers.length;

    int amountRemainingPlayers = amountPlayers % maxPlayersByTeam;
    int amountCompleteTeams =
        (amountPlayers - amountRemainingPlayers) ~/ maxPlayersByTeam;
    int maxPromised = maxPlayersByTeam - amountRemainingPlayers;
    print("max line players: $maxPlayersByTeam");
    print("amount line players: $amountPlayers");
    print("remaining line players: $amountRemainingPlayers");
    print("max promised to incomplete team: $maxPromised");
    print("amount complete teams: $amountCompleteTeams");
    print("balance with goalkeeper: $balanceGoalkeeper");

    List<Shirt> remainingShirts =
        _defineShirtsToCompleteTeams(amountCompleteTeams);

    if (amountRemainingPlayers > 0) {
      teams.add(_defineIncompleteTeam(remainingShirts.firstOrNull));
      _createIncompleteTeamToBalanceWithPromisedPlayers(maxPromised);
      _balanceTeamsByStars(arrivingPlayers.toList());
    } else {
      _balanceTeamsByStars(arrivingPlayers.toList());
      teams.add(_defineIncompleteTeam(remainingShirts.firstOrNull));
      _createPromisedTeamNotBalanced(maxPlayersByTeam);
    }
    print('will add all');
    teamRepository.load(teams);
    print('has add all');
  }

  List<Shirt> _defineShirtsToCompleteTeams(int amountCompleteTeams) {
    List<Shirt> remainingShirts = [];
    print('will2 add all');
    remainingShirts.addAll(availableShirts);
    print('has2 add all');
    // create teams
    for (int i = 0; i < amountCompleteTeams; i++) {
      Shirt? shirt = remainingShirts.firstOrNull;
      remainingShirts.remove(shirt);

      teams.add(Team.complete(
        shirt: shirt ?? Shirt.undefined(),
      ));
    }
    return remainingShirts;
  }

  void _balanceTeamsByStars(List<PresencePlayer> listPlayers) {
    // listPlayers.addAll(shufflePromisesLimited);
    List<PresencePlayer> sortedPlayersByStars =
        _sortByStarsShufflingEquals(listPlayers);
    final maxPlayersByTeam = settings.getMaxPlayersByTeam();

    // split listPlayers based on sort of starts
    for (int i = 0; i < listPlayers.length; i++) {
      print('index $i of ${listPlayers.length}');
      PresencePlayer _ = listPlayers[i];

      if (sortedPlayersByStars.isEmpty) {
        print('sortedPlayersByStars.isEmpty');
        return;
      }

      teams.sort((a, b) {
        if (a.incomplete || b.incomplete) return -1;
        return a.calculatePower().compareTo(b.calculatePower());
      });

      for (Team team in teams) {
        if (team.players.length >= maxPlayersByTeam) {
          print('team full ${team.shirt.name}');
          break;
        }

        var nextGoodPlayer = sortedPlayersByStars.first;
        print('apply ${nextGoodPlayer.player.name} in ${team.shirt.name}');

        print('will add player');
        team.addPlayer(nextGoodPlayer);
        print('has add player');
        sortedPlayersByStars.remove(nextGoodPlayer);
      }
    }
  }

  void _createIncompleteTeamToBalanceWithPromisedPlayers(int promisedNeeded) {
    var promisedListPlayers = presencePlayerRepository.getComputedConfirmedPresencePlayers().value;

    promisedListPlayers.shuffle();
    var shufflePromisesLimited = promisedListPlayers.toList();
    if (promisedListPlayers.length >= promisedNeeded) {
      shufflePromisesLimited =
          promisedListPlayers.getRange(0, promisedNeeded).toList();
    } else {
      var needs = promisedNeeded - shufflePromisesLimited.length;
      for (int i = 0; needs > i; i++) {
        shufflePromisesLimited.add(PresencePlayer.ghost(Player.ghost()));
      }
    }

    int indexIncomplete = teams.indexWhere((element) => element.incomplete);
    final Team incompleteTeam = teams[indexIncomplete];
    print('will3 add all');

    final Team cloneIncompleteTeam = incompleteTeam.copyWith(players: incompleteTeam.players + shufflePromisesLimited);
    print('has3 add all');
    teams[indexIncomplete] = cloneIncompleteTeam;

    print('team incomplete with not arrived players\n'
        ': ${cloneIncompleteTeam.players.toString()}');
  }

  void _createPromisedTeamNotBalanced(int maxPlayersByTeam) {
    var promisedListPlayers = presencePlayerRepository.getComputedConfirmedPresencePlayers().value;

    promisedListPlayers.shuffle();
    var shufflePromisesLimited = promisedListPlayers.toList();
    if (promisedListPlayers.length > maxPlayersByTeam) {
      shufflePromisesLimited =
          promisedListPlayers.getRange(0, maxPlayersByTeam).toList();
    }

    var incompleteTeam = teams.firstWhere((element) => element.incomplete);
    incompleteTeam.players.addAll(shufflePromisesLimited);

    print('team incomplete not balanced only with not arrived players\n'
        ': ${incompleteTeam.players.toString()}');
  }

  bool _isTeamFullOfPromisedPlayers(Team team, int maxPromised) {
    var bool = team.players.toList()
        .where((element) => element.statePresence == StatePresence.confirmed)
        .length >= maxPromised;
    print('isTeamFullOfPromisedPlayers ${team.shirt.name} $bool');
    return bool;
  }

  List<PresencePlayer> _sortByStarsShufflingEquals(
      List<PresencePlayer> players) {
    players.sort((a, b) {
      final compare = a.player.stars.compareTo(b.player.stars);
      if (compare == 0) {
        return Random().nextInt(3) - 1;
      }
      return compare;
    });
    return players.reversed.toList();
  }

  void printTeams() {
    for (Team team in teams) {
      print('Time ${team.shirt.name}: Poder: ${team.calculatePower()} '
          '\nQuantidade: ${team.players.length}');
      for (PresencePlayer arrivingPlayer in team.players) {
        print(
            'Jogador: ${arrivingPlayer.player.stars} - ${arrivingPlayer.player.name}');
      }
      print("---------");
    }

    final a = Player.normal("A", 3.5);
    final b = Player.normal("B", 3.5);
    final c = Player.normal("C", 3.5);
    final d = Player.normal("D", 3.1);
    final list = [a, b, c, d];
    list.sort((a, b) {
      return Random().nextInt(3) - 1;
    });
    print('MAIOR ${list.toString()} ${Random().nextInt(3) - 1}');
  }

  Team _defineIncompleteTeam(
    Shirt? shirt,
  ) {
    Team team = Team.incomplete(
      shirt: shirt ?? Shirt.undefined(),
    );
    print('incomplete team: ${team.shirt.name}');
    return team;
  }

  Team _createIncompleteTeamByRandomNumber(
    List<Player> players,
    Shirt? shirt,
    int remainingPlayers,
  ) {
    Team team = Team.incomplete(
      shirt: shirt ?? Shirt.undefined(),
    );
    print('incomplete team: ${team.shirt.name}');

    var random = Random();

    for (int i = 0; i < remainingPlayers; i++) {
      // Value is >= 0 and < presence.players.length
      var numberRandomized = random.nextInt(players.length);

      var unluckyPlayer = players[numberRandomized];
      players.remove(unluckyPlayer);
      print('Unlucky: ${unluckyPlayer.name}');

      // team.addPlayer(unluckyPlayer);
    }

    return team;
  }
}
