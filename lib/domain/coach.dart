import 'dart:math';

import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/presence.dart';
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
  Coach();

  final PresencePlayers presence = GetIt.I.get<PresencePlayers>();

  final int maxLinePlayersByTeam = 6;

  final ListSignal<Team> teams = ListSignal([]);

  void balanceTeams() {
    teams.clear();
    int amountPlayers = presence.arrived.value.length;
    int amountRemainingPlayers = amountPlayers % maxLinePlayersByTeam;
    int amountCompleteTeams =
        (amountPlayers - amountRemainingPlayers) ~/ maxLinePlayersByTeam;
    print("max line players: $maxLinePlayersByTeam");
    print("amount line players: $amountPlayers");
    print("remaining line players: $amountRemainingPlayers");
    print("amount complete teams: $amountCompleteTeams");

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

    // Remove unlucky players to mount the incomplete team.
    var incompleteTeam = createIncompleteTeamByRandomNumber(
      shirts.firstOrNull,
      amountRemainingPlayers,
    );
    balanceTeamsByStars();

    teams.add(incompleteTeam);
  }

  void balanceTeamsByStars() {
    var listPlayers = presence.arrived.value.map((e) => e.player).toList();
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
        if (team.players.length > maxLinePlayersByTeam) {
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

  Team createIncompleteTeamByRandomNumber(Shirt? shirt, int remainingPlayers) {
    Team team = Team(
      shirt: shirt ?? Shirt.undefined(),
    );
    print('incomplete team: ${team.shirt.name}');

    var random = Random();
    var players = presence.arrived.value.map((e) => e.player).toList();

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
