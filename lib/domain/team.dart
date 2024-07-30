import 'package:equatable/equatable.dart';
import 'package:equilibrium/domain/home_arriving_player.dart';
import 'package:equilibrium/domain/shirt.dart';

class Team extends Equatable {
  final Shirt shirt;
  final List<HomeArrivingPlayer> players = [];
  late final bool incomplete;

  Team._({required this.shirt}) : incomplete = false;

  Team.complete({required this.shirt}) {
    incomplete = false;
  }

  Team.incomplete({required this.shirt}) {
    incomplete = true;
  }

  void addPlayer(HomeArrivingPlayer homeArrivingPlayer) {
    players.add(homeArrivingPlayer);
  }

  void removePlayer(HomeArrivingPlayer homeArrivingPlayer) {
    players.remove(homeArrivingPlayer);
  }

  double calculatePower() {
    return players.fold(0, (previousValue, element) {
      return previousValue + element.player.stars;
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
