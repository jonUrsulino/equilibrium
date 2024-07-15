import 'package:equatable/equatable.dart';
import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/shirt.dart';

class Team extends Equatable {
  final Shirt shirt;
  final List<Player> players = [];

  Team({required this.shirt});

  void addPlayer(Player player) {
    print('${shirt.name} ${player.name}');
    players.add(player);
  }

  void removePlayer(Player player) {
    players.remove(player);
  }

  @override
  List<Object> get props => [shirt, players];

  Team copyWith({Shirt? shirt}) {
    return Team(
      shirt: shirt ?? this.shirt,
    );
  }
}
