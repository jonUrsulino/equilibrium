import 'dart:math';

import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/domain/team.dart';
import 'package:equilibrium/domain/shirt.dart';

final List<Shirt> availableShirts = [
  Shirt.white(),
  Shirt.black(),
  Shirt.green(),
  Shirt.blue()
];

class Coach {
  Coach(this.presence);

  final PresencePlayers presence;

  final int maxLinePlayersByTeam = 6;

  List<Team> teams = [];

  void balanceTeams() {
    int amountPlayers = presence.players.length;
    int amountRemainingPlayers = amountPlayers % maxLinePlayersByTeam;
    int amountCompleteTeams =
        (amountPlayers - amountRemainingPlayers) ~/ maxLinePlayersByTeam;
    print("max line players: $maxLinePlayersByTeam");
    print("amount line players: $amountPlayers");
    print("remaining line players: $amountRemainingPlayers");
    print("amount complete team: $amountCompleteTeams");
    // define max teams based on amount of shirts.
    // if (teamValidAmount > availableShirts.length) {
    //   teamValidAmount = availableShirts.length;
    // }

    List<Shirt> shirts = availableShirts;
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
    List<Player> sortedPlayersByStars = sortByStars(presence.players);

    // split players based on sort of starts
    for (Player _ in presence.players) {
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
      int value = 0;
      print('Time ${team.shirt.name}: ${team.players.length}');
      for (Player player in team.players) {
        print('Jogador: ${player.stars} - ${player.name}');
        value += player.stars.toInt();
      }
      print('Poder: $value');
      print("---------");
    }
  }

  Team createIncompleteTeamByRandomNumber(Shirt? shirt, int remainingPlayers) {
    Team team = Team(
      shirt: shirt ?? Shirt.undefined(),
    );
    print('incomplete team: ${team.shirt.name}');

    var random = Random();
    for (int i = 0; i < remainingPlayers; i++) {
      // Value is >= 0 and < presence.players.length
      var numberRandomized = random.nextInt(presence.players.length);

      var unluckyPlayer = presence.players[numberRandomized];
      presence.players.remove(unluckyPlayer);
      print('Unlucky: ${unluckyPlayer.name}');

      team.addPlayer(unluckyPlayer);
    }

    return team;
  }
}
