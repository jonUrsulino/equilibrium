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

    if (amountRemainingPlayers > 2) {
      teams.add(defineIncompleteTeam(remainingShirts.firstOrNull));
      balanceTeamsByStars(arrivingPlayers.toList());
    } else {
      balanceTeamsByStars(arrivingPlayers.toList());
    }

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
    var promisedListPlayers = presence.promisedSortedByName.value;
    promisedListPlayers.shuffle();
    listPlayers.addAll(promisedListPlayers);
    List<HomeArrivingPlayer> sortedPlayersByStars = sortByStars(listPlayers);
    final maxPlayersByTeam = settings.getMaxPlayersByTeam();

    // split listPlayers based on sort of starts
    for (int i = 0; i < listPlayers.length; i++) {
      print('index $i of ${listPlayers.length}');
      HomeArrivingPlayer _ = listPlayers[i];

      if (sortedPlayersByStars.isEmpty) {
        print('sortedPlayersByStars.isEmpty');
        return;
      }

      teams.sort((a, b) {
        if (a.incomplete) return -1;
        if (b.incomplete) return -1;
        return a.calculatePower().compareTo(b.calculatePower());
      });

      for (Team team in teams) {
        if (team.players.length >= maxPlayersByTeam) {
          print('team full ${team.shirt.name}');
          break;
        }
        var nextGoodPlayer = sortedPlayersByStars.first;
        if (!nextGoodPlayer.hasArrived && !team.incomplete) {
          print('avoid ${nextGoodPlayer.player.name} in ${team.shirt.name}');
          nextGoodPlayer =
              sortedPlayersByStars.firstWhere((element) => element.hasArrived);
        }
        print('apply ${nextGoodPlayer.player.name} in ${team.shirt.name}');

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
