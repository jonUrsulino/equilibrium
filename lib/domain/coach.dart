import 'dart:async';
import 'dart:math';

import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/model/shirt.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/repository/team_repository.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:flutter/cupertino.dart';
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

  void balanceTeams(List<PresencePlayer> arrivingPlayers) {
    print("balanceTeams");
    teams.clear();
    final maxPlayersByTeam = settings.getMaxPlayersByTeam();

    final balanceGoalkeeper = settings.isConsideredBalanceWithGoalkeeper();
    print("INIT properties");
    int amountPlayers = arrivingPlayers.length;

    int amountRemainingPlayers = amountPlayers % maxPlayersByTeam;
    int amountCompleteTeams =
        (amountPlayers - amountRemainingPlayers) ~/ maxPlayersByTeam;
    int maxConfirmedPlayers = maxPlayersByTeam - amountRemainingPlayers;
    print("max line players: $maxPlayersByTeam");
    print("amount line players: $amountPlayers");
    print("remaining line players: $amountRemainingPlayers");
    print("max promised to incomplete team: $maxConfirmedPlayers");
    print("amount complete teams: $amountCompleteTeams");
    print("balance with goalkeeper: $balanceGoalkeeper");

    List<Shirt> remainingShirts = _defineShirtsToCompleteTeams(amountCompleteTeams);

    if (amountRemainingPlayers <= 0) {
      print("1. Caiu aqui $amountRemainingPlayers");
      _balanceTeamsByStars(arrivingPlayers.toList());
      _createConfirmedIncompleteTeam(remainingShirts, maxPlayersByTeam);
    } else {
      print("2. Caiu aqui $amountRemainingPlayers");
      teams.add(_defineIncompleteTeam(remainingShirts.firstOrNull));
      _createIncompleteTeamToBalanceWithConfirmedPlayers(maxConfirmedPlayers);
      _balanceTeamsByStars(arrivingPlayers.toList());
    }
    teamRepository.load(teams);
  }

  List<PresencePlayer> getSyncArrivedPlayersFiltered(bool balanceGoalkeeper) {
    List<PresencePlayer> arrivedPlayersFiltered = List.empty(growable: true);
    getFutureArrivedPlayersFiltered(balanceGoalkeeper).then((value) {
      arrivedPlayersFiltered.addAll(value);
    },).whenComplete(() {
      print("DONE!");
    });
    return arrivedPlayersFiltered;
  }

  Future<List<PresencePlayer>> getFutureArrivedPlayersFiltered(bool balanceGoalkeeper) async {
    print("getArrivedPlayersFiltered");
    // List<PresencePlayer> arrivingPlayers = presencePlayerRepository.getComputedArrivedPresencePlayers().value;
    List<PresencePlayer> futureArrivedPresencePlayers;
    if (balanceGoalkeeper) {
      futureArrivedPresencePlayers = await presencePlayerRepository.getFuturePresencePlayersWhere(
          StatePresence.arrived
      );
      print("balanceGoalkeeper getFuturePresencePlayersWhere ${futureArrivedPresencePlayers.length}");

    } else {
      futureArrivedPresencePlayers = await presencePlayerRepository.getFuturePresencePlayersFiltered(
          wherePresence: StatePresence.arrived,
          withGoalkeeper: false
      );
    }
    print("getArrivedPlayersFiltered $futureArrivedPresencePlayers");
    var lists = await futureArrivedPresencePlayers;
    for (var item in lists) {
      print("getArrivedPlayersFiltered item: ${item.player.name}");
    }

    // return await streamArrivedPresencePlayers.first;

    // List<PresencePlayer> arrivingPlayers = List.empty(growable: true);
    // for (int i = 0; i < futureArrivedPresencePlayers.length; i++) {
    //   PresencePlayer items = futureArrivedPresencePlayers[i];
    //   print("getArrivedPlayersFiltered: $items");
    //   arrivingPlayers = items;
    // }
    // print("getArrivedPlayersFiltered arrivingPlayers: $arrivingPlayers");

    return futureArrivedPresencePlayers.toList();
  }

  void _createConfirmedIncompleteTeam(List<Shirt> remainingShirts, int maxPlayersByTeam) async {
    var stream = presencePlayerRepository.getStreamPresencePlayersWhere(StatePresence.confirmed);

    await for (List<PresencePlayer> promisedListPlayers in stream) {
      if (promisedListPlayers.isNotEmpty) {
        teams.add(_defineIncompleteTeam(remainingShirts.firstOrNull));
        _createPromisedTeamNotBalanced(promisedListPlayers, maxPlayersByTeam);
      }
    }
  }

  List<Shirt> _defineShirtsToCompleteTeams(int amountCompleteTeams) {
    List<Shirt> remainingShirts = [];
    remainingShirts.addAll(availableShirts);

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
    List<PresencePlayer> sortedPlayersByStars = _sortByStarsShufflingEquals(listPlayers);
    print("sorted $sortedPlayersByStars");
    print("sorted length ${sortedPlayersByStars.length}");
    final maxPlayersByTeam = settings.getMaxPlayersByTeam();
    print("$listPlayers");

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
        print('loop team: ${team.shirt.name} ${team.incomplete}');
        if (team.players.length >= maxPlayersByTeam) {
          print('team full ${team.shirt.name}');
          continue;
        }

        if (sortedPlayersByStars.isEmpty) {
          print('sortedPlayersByStars.isEmpty');
          return;
        }
        var nextGoodPlayer = sortedPlayersByStars.first;
        print("add player: ${nextGoodPlayer.player.name}");

        team.addPlayer(nextGoodPlayer.player);
        sortedPlayersByStars.remove(nextGoodPlayer);
      }
    }
  }

  void _createIncompleteTeamToBalanceWithConfirmedPlayers(int confirmedPlayersNeeded) async {
    var stream = presencePlayerRepository.getStreamPresencePlayersWhere(StatePresence.confirmed);
    await for (final List<PresencePlayer> confirmedPlayers in stream) {

      confirmedPlayers.shuffle();
      List<PresencePlayer> shuffleConfirmedPlayersLimited = confirmedPlayers.toList();
      if (confirmedPlayers.length >= confirmedPlayersNeeded) {
        shuffleConfirmedPlayersLimited = confirmedPlayers.getRange(0, confirmedPlayersNeeded).toList();
      } else {
        var needs = confirmedPlayersNeeded - shuffleConfirmedPlayersLimited.length;
        for (int i = 0; needs > i; i++) {
          shuffleConfirmedPlayersLimited.add(PresencePlayer.ghost(Player.ghost()));
        }
      }

      int indexIncomplete = teams.indexWhere((element) => element.incomplete);
      final Team incompleteTeam = teams[indexIncomplete];

      final Team cloneIncompleteTeam = incompleteTeam.copyWith(
        players: incompleteTeam.players + shuffleConfirmedPlayersLimited.map((e) => e.player).toList(),
      );
      teams[indexIncomplete] = cloneIncompleteTeam;

      print('team incomplete with not arrived players\n'
          ': ${cloneIncompleteTeam.players.toString()}');
    }
  }

  void _createPromisedTeamNotBalanced(List<PresencePlayer> promisedListPlayers, int maxPlayersByTeam) {
    promisedListPlayers.shuffle();
    var shufflePromisesLimited = promisedListPlayers.toList();
    if (promisedListPlayers.length > maxPlayersByTeam) {
      shufflePromisesLimited =
          promisedListPlayers.getRange(0, maxPlayersByTeam).toList();
    }

    var incompleteTeam = teams.firstWhere((element) => element.incomplete);
    incompleteTeam.players.addAll(shufflePromisesLimited.map((e) => e.player).toList());

    var ghostsLength = settings.maxPlayersByTeam.value - incompleteTeam.players.length;
    for (int i = 0; i < ghostsLength; i++) {
      incompleteTeam.players.add(Player.ghost());
    }

    print('team incomplete not balanced only with not arrived players\n'
        ': ${incompleteTeam.players.toString()}');
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
      for (Player player in team.players) {
        print(
            'Jogador: ${player.stars} - ${player.name}');
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
    print('incomplete team: ${team.shirt.name} ${team.incomplete}');
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
