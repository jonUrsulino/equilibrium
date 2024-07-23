import 'package:equatable/equatable.dart';

class Player extends Equatable {
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
}
