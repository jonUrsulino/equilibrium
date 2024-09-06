

import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/presence_player.dart';
import 'package:equilibrium/domain/repository/player_repository.dart';

class GetInitialPresencePlayersSortByStarts {
  GetInitialPresencePlayersSortByStarts({required this.repository});

  final PlayerRepository repository;

  List<PresencePlayer> execute() {
    List<Player> players = repository.getPlayers();
    return players
        .map((player) => PresencePlayer.initial(player))
        .toList()
        ..sort((a, b) => a.player.name.compareTo(b.player.name));
  }
}