

import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:signals/signals.dart';

class GetComputedPresencePlayersSortedByName {
  GetComputedPresencePlayersSortedByName({required this.repository});

  final PresencePlayerRepository repository;

  Computed<List<PresencePlayer>> execute() {
    return computed<List<PresencePlayer>>(() => repository.getPresencePlayers().values
        .where((element) {
          return element.statePresence == StatePresence.initial;
        })
        .toList()..sort((a, b) => a.player.name.compareTo(b.player.name),
    ));
  }

}