import 'package:equatable/equatable.dart';
import 'package:equilibrium/domain/player.dart';

class HomeArrivingPlayer extends Equatable {
  const HomeArrivingPlayer(
    this.player,
    this.stars,
    this.hasArrived,
  );

  factory HomeArrivingPlayer.initial(Player player) {
    return HomeArrivingPlayer(player, 0, false);
  }

  final Player player;
  final double stars;
  final bool hasArrived;

  @override
  List<Object?> get props => [player, hasArrived];

  HomeArrivingPlayer copyWith(Player? player, double? stars, bool? hasArrived) {
    return HomeArrivingPlayer(
      player = player ?? this.player,
      stars = stars ?? this.stars,
      hasArrived = hasArrived ?? this.hasArrived,
    );
  }
}
