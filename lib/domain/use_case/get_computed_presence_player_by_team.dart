
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:signals/signals.dart';

class GetComputedPresencePlayerByName {
  GetComputedPresencePlayerByName({required this.repository});

  final PresencePlayerRepository repository;

  Computed<PresencePlayer?> execute(String playerName) {
    return computed<PresencePlayer?>(() => repository.getPresencePlayers()[playerName]);
  }

  void dispose() {
    // repository.dispose();
  }
}