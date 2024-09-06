import 'dart:core';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:equilibrium/domain/model/player.dart';

class PresencePlayer extends Equatable
    implements Comparable<PresencePlayer> {
  const PresencePlayer._({
    required this.player,
    required this.statePresence,
    required this.isUnlucky,
  });

  const PresencePlayer.initial(
    this.player,
  )   : statePresence = StatePresence.initial,
        isUnlucky = false;

  final Player player;
  final StatePresence statePresence;
  final bool isUnlucky;

  @override
  List<Object?> get props => [player, statePresence, isUnlucky];

  PresencePlayer copyWith({
    Player? player,
    StatePresence? statePresence,
    bool? hasArrived,
    bool? isUnlucky,
  }) {
    return PresencePlayer._(
      player: player ?? this.player,
      statePresence: statePresence ?? this.statePresence,
      isUnlucky: isUnlucky ?? this.isUnlucky,
    );
  }

  @override
  int compareTo(PresencePlayer other) {
    print("-------987654323456789------------");
    if (player.stars == other.player.stars) {
      var returns = Random().nextInt(3) - 1;
      print('RETURNSSSSS: ${player.name} ${other.player.name} $returns');
      return returns;
    }
    return 0;
  }
}

enum StatePresence {
  initial, confirmed, arrived
}
