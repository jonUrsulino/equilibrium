

import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/player_repository.dart';

class GetInitialPresencePlayersSortByNames {
  GetInitialPresencePlayersSortByNames({required this.repository});

  final PlayerRepository repository;

  List<PresencePlayer> execute() {
    return repository.getPlayers()
        .map((player) => PresencePlayer.initial(player))
        .toList()
      ..sort((a, b) => a.player.name.compareTo(b.player.name));
  }
}