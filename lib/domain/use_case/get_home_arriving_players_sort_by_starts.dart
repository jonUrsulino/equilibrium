

import 'dart:async';

import 'package:equilibrium/domain/home_arriving_player.dart';
import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/repository/player_repository.dart';

class GetHomeArrivingPlayersSortByStarts {
  GetHomeArrivingPlayersSortByStarts({required this.repository});

  final PlayerRepository repository;

  List<HomeArrivingPlayer> execute() {
    List<Player> players = repository.getPlayers();
    return players
        .map((player) => HomeArrivingPlayer.initial(player))
        .toList()
        ..sort((a, b) => a.player.name.compareTo(b.player.name));
  }
}