import 'dart:math';

import 'package:equilibrium/domain/path_persistence.dart';
import 'package:simple_persistence/simple_persistence.dart';

class Player extends Storable implements Comparable<Player> {
  Player(this.name, this.stars, this.isGoalkeeper);

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
    return Player(
      "Vaga aberta",
      3,
      false,
    );
  }

  final String name;
  final double stars;
  final bool isGoalkeeper;

  Player.fromMap(Map<String, dynamic> map) :
        name = map['name'],
        stars = map['stars'],
        isGoalkeeper = map['isGoalkeeper'];

  Player copyWith(String? name, double? stars, bool? isGoalkeeper) {
    return Player(
      name ?? this.name,
      stars ?? this.stars,
      isGoalkeeper ?? this.isGoalkeeper,
    )..id = id;
  }

  @override
  int compareTo(Player other) {
    if (stars == other.stars) {
      return Random().nextInt(3) - 1;
    }
    return compareTo(other);
  }

  @override
  Map get data => {
    'name': name,
    'stars': stars,
    'isGoalkeeper': isGoalkeeper,
  };

  static final store = JsonFileStore<Player>(
      path: PathPersistence.pathPlayers,
  );
}
