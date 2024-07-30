import 'dart:core';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:equilibrium/domain/player.dart';

class HomeArrivingPlayer extends Equatable
    implements Comparable<HomeArrivingPlayer> {
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
  List<Object?> get props => [player, hasArrived, isUnlucky];

  HomeArrivingPlayer copyWith({
    Player? player,
    bool? hasArrived,
    bool? isUnlucky,
  }) {
    return HomeArrivingPlayer._(
      player: player ?? this.player,
      hasArrived: hasArrived ?? this.hasArrived,
      isUnlucky: isUnlucky ?? this.isUnlucky,
    );
  }

  @override
  int compareTo(HomeArrivingPlayer other) {
    print("-------987654323456789------------");
    if (player.stars == other.player.stars) {
      var returns = Random().nextInt(3) - 1;
      print('RETURNSSSSS: ${player.name} ${other.player.name} $returns');
      return returns;
    }
    return 0;
  }
}
