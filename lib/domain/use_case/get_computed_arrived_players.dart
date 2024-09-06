
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:signals/signals.dart';

class GetComputedArrivedPresencePlayers {
  GetComputedArrivedPresencePlayers({required this.repository});

  final PresencePlayerRepository repository;

  Computed<List<PresencePlayer>> execute() {
    return computed<List<PresencePlayer>>(() {
      return repository.getPresencePlayers().values.where((element) {
        return element.statePresence == StatePresence.arrived;
      }).toList();
    });
  }
}