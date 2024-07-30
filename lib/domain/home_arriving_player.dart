import 'package:equatable/equatable.dart';
import 'package:equilibrium/domain/player.dart';

class HomeArrivingPlayer extends Equatable {
  const HomeArrivingPlayer(
    this.player,
  );

  factory HomeArrivingPlayer.initial(Player player) {
    return HomeArrivingPlayer(player);
  }

  final Player player;

  @override
  List<Object?> get props => [player];

  HomeArrivingPlayer copyWith(Player? player) {
    return HomeArrivingPlayer(
      player = player ?? this.player,
    );
  }
}
