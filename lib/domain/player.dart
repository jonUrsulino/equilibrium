import 'package:equatable/equatable.dart';

class Player extends Equatable {
  const Player(this.name, this.stars);

  final String name;
  final double stars;

  @override
  List<Object?> get props => [name, stars];

  Player copyWith(String? name, double stars) {
    return Player(
      name ?? this.name,
      stars <= 0 ? stars : this.stars,
    );
  }
}
