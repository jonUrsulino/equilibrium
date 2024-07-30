import 'package:equatable/equatable.dart';
import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/shirt.dart';

class Team extends Equatable {
  final Shirt shirt;
  final List<Player> players = [];
  late final bool incomplete;

  Team._({required this.shirt}) : incomplete = false;

  Team.complete({required this.shirt}) {
    incomplete = false;
  }

  Team.incomplete({required this.shirt}) {
    incomplete = true;
  }

  void addPlayer(Player player) {
    players.add(player);
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
  List<Object> get props => [shirt, players];

  Team copyWith({Shirt? shirt}) {
    return Team._(
      shirt: shirt ?? this.shirt,
    );
  }
}
