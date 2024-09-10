import 'package:equatable/equatable.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/model/shirt.dart';

class Team extends Equatable {
  final Shirt shirt;
  final List<PresencePlayer> players;
  final bool incomplete;

  Team._({
    required this.shirt,
    required this.players,
  }) : incomplete = false;

  Team.complete({required this.shirt}) : incomplete = false, players = List.empty(growable: true);

  Team.incomplete({required this.shirt}) : incomplete = true, players = List.empty(growable: true);

  void addPlayer(PresencePlayer presencePlayer) {
    players.add(presencePlayer);
  }

  void removePlayer(PresencePlayer presencePlayer) {
    players.remove(presencePlayer);
  }

  double calculatePower() {
    return players.fold(0, (previousValue, element) {
      return previousValue + element.player.stars;
    });
  }

  List<PresencePlayer> arrivedPlayers() {
    return players
        .where((element) => element.statePresence == StatePresence.arrived)
        .toList();
  }

  int ghostPlayersLength() {
    return players
        .where((element) => element.statePresence == StatePresence.ghost)
        .length;
  }

  @override
  List<Object> get props => [shirt, players];

  Team copyWith({Shirt? shirt, List<PresencePlayer>? players}) {
    var team = Team._(
      shirt: shirt ?? this.shirt,
      players: players ?? this.players
    );
    // if (players != null) {
    //   team.players.clear();
    //   team.players.addAll(players!);
    // }
    return team;
  }
}
