import 'dart:math';

import 'package:equatable/equatable.dart';

class Player extends Equatable implements Comparable<Player> {
  const Player(this.name, this.stars, this.isGoalkeeper);

  factory Player.normal(String name, double stars) {
    return Player(
      name,
      stars,
      false,
    );
  }

  factory Player.goalkeeper(String name, double stars) {
    return Player(
      name,
      stars,
      true,
    );
  }

  factory Player.ghost() {
    return const Player(
      "Vaga aberta",
      3,
      false,
    );
  }

  final String name;
  final double stars;
  final bool isGoalkeeper;

  @override
  List<Object?> get props => [name, stars, isGoalkeeper];

  Player copyWith(String? name, double? stars, bool? isGoalkeeper) {
    return Player(
      name ?? this.name,
      stars ?? this.stars,
      isGoalkeeper ?? this.isGoalkeeper,
    );
  }

  @override
  int compareTo(Player other) {
    if (stars == other.stars) {
      return Random().nextInt(3) - 1;
    }
    return compareTo(other);
  }
}
