import 'package:equatable/equatable.dart';
import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/model/shirt.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';

class Team extends Equatable {
  final Shirt shirt;
  final List<PresencePlayer> presencePlayers;
  final List<Player> players;
  final bool incomplete;

  const Team._({
    required this.shirt,
    required this.players,
    required this.presencePlayers,
  }) : incomplete = false;

  Team.complete({required this.shirt}) :
        incomplete = false,
        players = List.empty(growable: true),
        presencePlayers = List.empty(growable: true);

  Team.incomplete({required this.shirt}) :
        incomplete = true,
        players = List.empty(growable: true),
        presencePlayers = List.empty(growable: true);

  void addPresencePlayer(PresencePlayer presencePlayer) {
    presencePlayers.add(presencePlayer);
    addPlayer(presencePlayer.player);
  }

  void addPlayer(Player player) {
    players.add(player);
  }

  void removePresencePlayer(PresencePlayer presencePlayer) {
    presencePlayers.remove(presencePlayer);
    removePlayer(presencePlayer.player);
  }

  void removePlayer(Player player) {
    players.remove(player);
  }

  double calculatePower() {
    return players.fold(0, (previousValue, element) {
      return previousValue + element.stars;
    });
  }

  @override
  List<Object> get props => [shirt, players, presencePlayers];

  Team copyWith({Shirt? shirt, List<Player>? players, List<PresencePlayer>? presencePlayers}) {
    var team = Team._(
      shirt: shirt ?? this.shirt,
      players: players ?? this.players,
      presencePlayers: presencePlayers ?? this.presencePlayers
    );
    return team;
  }
}

extension TeamPresence on Team {
  List<PresencePlayer> actualPresencePlayers(PresencePlayerRepository repository) {
    return repository
        .getPresencePlayersByNames(players.map((e) => e.name).toList());
  }

  List<PresencePlayer> notArrivedPlayers(PresencePlayerRepository repository) {
    return actualPresencePlayers(repository)
        .where((element) => element.statePresence != StatePresence.arrived)
        .toList();
  }

  List<PresencePlayer> arrivedPlayers(PresencePlayerRepository repository) {
    return actualPresencePlayers(repository)
        .where((element) => element.statePresence == StatePresence.arrived)
        .toList();
  }
}