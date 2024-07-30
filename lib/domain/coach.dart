import 'dart:math';

import 'package:equilibrium/domain/home_arriving_player.dart';
import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:equilibrium/domain/team.dart';
import 'package:equilibrium/domain/shirt.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';

//TODO: put it in the settings to edit colors and names of teams.
final List<Shirt> availableShirts = [
  Shirt.white(),
  Shirt.black(),
  Shirt.green(),
  Shirt.blue()
];

class Coach {
  Coach();

  final PresencePlayers presence = GetIt.I.get<PresencePlayers>();
  final Settings settings = GetIt.I.get<Settings>();

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

    List<Shirt> remainingShirts =
        defineShirtsToCompleteTeams(amountCompleteTeams);
    // final List<HomeArrivingPlayer> listPlayers =
    //     arrivingPlayers.map((e) => e).toList();

    // Remove unlucky players to mount the incomplete team.
    // var incompleteTeam = createIncompleteTeamByRandomNumber(
    //   listPlayers,
    //   remainingShirts.firstOrNull,
    //   amountRemainingPlayers,
    // );

    teams.add(defineIncompleteTeam(remainingShirts.firstOrNull));
    balanceTeamsByStars(arrivingPlayers.toList());

    // teams.add(incompleteTeam);
  }

  List<Shirt> defineShirtsToCompleteTeams(int amountCompleteTeams) {
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

  void balanceTeamsByStars(List<HomeArrivingPlayer> listPlayers) {
    listPlayers.addAll(presence.promisedSortedByName.value);
    List<HomeArrivingPlayer> sortedPlayersByStars = sortByStars(listPlayers);

    // split listPlayers based on sort of starts
    for (HomeArrivingPlayer _ in listPlayers) {
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

  List<HomeArrivingPlayer> sortByStars(List<HomeArrivingPlayer> players) {
    players.sort((a, b) => a.player.stars.compareTo(b.player.stars));
    return players.reversed.toList();
  }

  void printTeams() {
    for (Team team in teams) {
      print('Time ${team.shirt.name}: Poder: ${team.calculatePower()} '
          '\nQuantidade: ${team.players.length}');
      for (HomeArrivingPlayer arrivingPlayer in team.players) {
        print(
            'Jogador: ${arrivingPlayer.player.stars} - ${arrivingPlayer.player.name}');
      }
      print("---------");
    }
  }

  Team defineIncompleteTeam(
    Shirt? shirt,
  ) {
    Team team = Team.incomplete(
      shirt: shirt ?? Shirt.undefined(),
    );
    print('incomplete team: ${team.shirt.name}');
    return team;
  }

  Team createIncompleteTeamByRandomNumber(
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
