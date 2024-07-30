import 'package:equatable/equatable.dart';
import 'package:equilibrium/domain/player.dart';

class HomeArrivingPlayer extends Equatable {
  const HomeArrivingPlayer._({
    required this.player,
    required this.hasArrived,
    required this.isUnlucky,
  });

  const HomeArrivingPlayer.initial(
    this.player,
  )   : hasArrived = false,
        isUnlucky = false;

  final Player player;
  final bool hasArrived;
  final bool isUnlucky;

  @override
  List<Object?> get props => [player];

  HomeArrivingPlayer copyWith(
    Player? player,
    bool? hasArrived,
    bool? isUnlucky,
  ) {
    return HomeArrivingPlayer._(
      player: player ?? this.player,
      hasArrived: hasArrived ?? this.hasArrived,
      isUnlucky: isUnlucky ?? this.isUnlucky,
    );
  }
}
