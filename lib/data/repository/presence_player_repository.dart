
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/use_case/get_presence_players_mapped_with_names.dart';
import 'package:signals_core/src/value/value.dart';

class PresencePlayerRepositoryImpl implements PresencePlayerRepository {
  PresencePlayerRepositoryImpl({required this.useCase});

  final GetPresencePlayersMappedWithNames useCase;

  late final MapSignal<String, PresencePlayer> _arriving = MapSignal(useCase.execute());

  @override
  MapSignal<String, PresencePlayer> getPresencePlayers() {
    return _arriving;
  }

  @override
  void playerArrived(PresencePlayer presencePlayer, bool value) {
    print('player arrived ${presencePlayer.player.name}');

    var changed = presencePlayer.copyWith(statePresence: StatePresence.arrived);
    _arriving[presencePlayer.player.name] = changed;
  }

  @override
  void playerConfirmed(PresencePlayer presencePlayer, bool value) {
    print('player promised ${presencePlayer.player.name}');

    var changed = presencePlayer.copyWith(statePresence: StatePresence.confirmed);
    _arriving[presencePlayer.player.name] = changed;
  }

  @override
  void playerMissed(PresencePlayer presencePlayer, bool value) {
    print('player missed ${presencePlayer.player.name}');

    var changed = presencePlayer.copyWith(statePresence: StatePresence.confirmed);
    _arriving[presencePlayer.player.name] = changed;
  }

  @override
  void playerCanceled(PresencePlayer presencePlayer) {
    print('player canceled ${presencePlayer.player.name}');

    var changed = presencePlayer.copyWith(statePresence: StatePresence.initial);
    _arriving[presencePlayer.player.name] = changed;
  }

  @override
  void addNewPlayer(PresencePlayer value) {
    if (!_arriving.containsKey(value.player.name)) {
      _arriving[value.player.name] = value;
    } else {
      print('Player name duplicated');
    }
  }

  @override
  PresencePlayer? getPlayerByName(String playerName) {
    return _arriving[playerName];
  }
}