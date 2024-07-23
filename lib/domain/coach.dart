import 'dart:math';

import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:equilibrium/domain/team.dart';
import 'package:equilibrium/domain/shirt.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';

final List<Shirt> availableShirts = [
  Shirt.white(),
  Shirt.black(),
  Shirt.green(),
  Shirt.blue()
];

class Coach {
  Coach({required this.settings});

  final PresencePlayers presence = GetIt.I.get<PresencePlayers>();
  final Settings settings;

  final ListSignal<Team> teams = ListSignal([]);

  void balanceTeams() {
    teams.clear();
    final maxPlayersByTeam = settings.getMaxPlayersByTeam();

    final balanceGoalkeeper = settings.isConsideredBalanceWithGoalkeeper();
    final arrivingPlayers = presence.getArrivedWith(balanceGoalkeeper).value;
    int amountPlayers = arrivingPlayers.length;

    int amountRemainingPlayers = amountPlayers % maxPlayersByTeam;
    int amountCompleteTeams =
        (amountPlayers - amountRemainingPlayers) ~/ maxPlayersByTeam;
    print("max line players: $maxPlayersByTeam");
    print("amount line players: $amountPlayers");
    print("remaining line players: $amountRemainingPlayers");
    print("amount complete teams: $amountCompleteTeams");
    print("balance with goalkeeper: $balanceGoalkeeper");

    List<Shirt> shirts = [];
    shirts.addAll(availableShirts);
    // create teams
    for (int i = 0; i < amountCompleteTeams; i++) {
      Shirt? shirt = shirts.firstOrNull;
      shirts.remove(shirt);

      teams.add(Team(
        shirt: shirt ?? Shirt.undefined(),
      ));
    }
    final listPlayers = arrivingPlayers.map((e) => e.player).toList();

    // Remove unlucky players to mount the incomplete team.
    var incompleteTeam = createIncompleteTeamByRandomNumber(
      listPlayers,
      shirts.firstOrNull,
      amountRemainingPlayers,
    );
    balanceTeamsByStars(listPlayers);

    teams.add(incompleteTeam);
  }

  void balanceTeamsByStars(List<Player> listPlayers) {
    List<Player> sortedPlayersByStars = sortByStars(listPlayers);

    // split listPlayers based on sort of starts
    for (Player _ in listPlayers) {
      teams.sort((a, b) {
        return a.calculatePower().compareTo(b.calculatePower());
      });

      for (Team team in teams) {
        if (sortedPlayersByStars.isEmpty) {
          return;
        }
        if (team.players.length >= settings.getMaxPlayersByTeam()) {
          break;
        }
        var nextGoodPlayer = sortedPlayersByStars.first;
        team.addPlayer(nextGoodPlayer);

        sortedPlayersByStars.remove(nextGoodPlayer);
      }
    }
  }

  List<Player> sortByStars(List<Player> players) {
    players.sort((a, b) => a.stars.compareTo(b.stars));
    return players.reversed.toList();
  }

  void printTeams() {
    for (Team team in teams) {
      print('Time ${team.shirt.name}: Poder: ${team.calculatePower()} '
          '\nQuantidade: ${team.players.length}');
      for (Player player in team.players) {
        print('Jogador: ${player.stars} - ${player.name}');
      }
      print("---------");
    }
  }

  Team createIncompleteTeamByRandomNumber(
      List<Player> players, Shirt? shirt, int remainingPlayers) {
    Team team = Team(
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

      team.addPlayer(unluckyPlayer);
    }

    return team;
  }
}
