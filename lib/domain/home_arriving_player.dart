import 'package:equatable/equatable.dart';
import 'package:equilibrium/domain/player.dart';

class HomeArrivingPlayer extends Equatable {
  const HomeArrivingPlayer(
    this.player,
    this.hasArrived,
  );

  factory HomeArrivingPlayer.initial(Player player) {
    return HomeArrivingPlayer(player, false);
  }

  final Player player;
  final bool hasArrived;

  @override
  List<Object?> get props => [player, hasArrived];

  HomeArrivingPlayer copyWith(Player? player, double? stars, bool? hasArrived) {
    return HomeArrivingPlayer(
      player = player ?? this.player,
      hasArrived = hasArrived ?? this.hasArrived,
    );
  }
}
