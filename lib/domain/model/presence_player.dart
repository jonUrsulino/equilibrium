import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/path_persistence.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_persistence/simple_persistence.dart';

class PresencePlayer extends Storable
    implements Comparable<PresencePlayer> {
  PresencePlayer._({
    required this.player,
    required this.statePresence,
  });

  PresencePlayer.initial(
    this.player,
  )   : statePresence = StatePresence.initial;

  PresencePlayer.ghost(
      this.player
      )   : statePresence = StatePresence.ghost;

  final Player player;
  final StatePresence statePresence;

  PresencePlayer copyWith({
    Player? player,
    StatePresence? statePresence,
    bool? hasArrived,
  }) {
    return PresencePlayer._(
      player: player ?? this.player,
      statePresence: statePresence ?? this.statePresence,
    )..id = id;
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

  @override
  Map get data => {
    'player': player,
    'statePresence': statePresence.index //TODO refactor it.
  };

  PresencePlayer.fromMap(Map<String, dynamic> map) :
        player = map['player'],
        statePresence = StatePresence.fromId(map['statePresence']);

  static final store = JsonFileStore<PresencePlayer>(
    path: PathPersistence.pathPresencePlayer,
  );
}

enum StatePresence {
  initial,
  confirmed,
  arrived,
  ghost;

  static StatePresence fromId(int index) {
    return StatePresence.values[index];
  }
}
