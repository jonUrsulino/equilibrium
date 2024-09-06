
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:signals/signals.dart';

class GetComputedConfirmedPlayersSortByName {
  GetComputedConfirmedPlayersSortByName({required this.repository});

  final PresencePlayerRepository repository;

  late final _confirmed = computed<List<PresencePlayer>>(() => repository.getPresencePlayers()
      .values
      .where((element) => element.statePresence == StatePresence.confirmed)
      .toList());

  Computed<List<PresencePlayer>> execute() {
    return computed<List<PresencePlayer>>(() => _confirmed.value.toList()..sort(
          (a, b) => a.player.name.compareTo(b.player.name),
    ));
  }
}