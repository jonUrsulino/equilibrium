

import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart';

class GetComputedPresencePlayersSortedByName {
  GetComputedPresencePlayersSortedByName({required this.repository});

  final PresencePlayerRepository repository;

  get _value => computed<List<PresencePlayer>>(() => repository.getPresencePlayers().values
      .where((element) {
    return element.statePresence == StatePresence.initial;
  })
      .toList()..sort((a, b) => a.player.name.compareTo(b.player.name),
  ));

  Computed<List<PresencePlayer>> execute() {
    return _value;
  }

  void dispose() {
    // repository.dispose();
  }
}