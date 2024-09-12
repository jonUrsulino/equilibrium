
import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/use_case/get_presence_players_mapped_with_names.dart';
import 'package:signals/signals.dart';
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
  void playerArrived(PresencePlayer presencePlayer) {
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

  //TODO: Refactor this to be sure about this playerName contains in map.
  @override
  Computed<PresencePlayer?> getComputedPlayerByName(String playerName) {
    return computed(() => getPresencePlayers()[playerName]);
  }

  @override
  Computed<List<PresencePlayer>> getComputedPresencePlayersOrderedByName() {
    return computed<List<PresencePlayer>>(() => getPresencePlayers().values
        .where((element) {
          return element.statePresence == StatePresence.initial;
        })
        .toList()..sort((a, b) => a.player.name.compareTo(b.player.name),
    ));
  }

  @override
  Computed<List<PresencePlayer>> getComputedArrivedPresencePlayers() {
    return computed<List<PresencePlayer>>(() {
      return getPresencePlayers().values.where((element) {
        return element.statePresence == StatePresence.arrived;
      }).toList();
    });
  }

  @override
  Computed<List<PresencePlayer>> getComputedArrivedAndGhostPresencePlayers() {
    return computed<List<PresencePlayer>>(() {
      return getPresencePlayers().values.where((element) {
        return element.statePresence == StatePresence.arrived ||
            element.statePresence == StatePresence.ghost;
      }).toList();
    });
  }

  @override
  Computed<List<PresencePlayer>> getComputedArrivedPresencePlayersWithoutGoalkeepers() {
    return computed<List<PresencePlayer>>(() {
      return getComputedArrivedPresencePlayers().get().where((element) {
        return !element.player.isGoalkeeper;
      }).toList();
    });
  }

  @override
  Computed<List<PresencePlayer>> getComputedConfirmedPresencePlayers() {
    return computed<List<PresencePlayer>>(() {
      return getPresencePlayers()
          .values
          .where((element) {
        return element.statePresence == StatePresence.confirmed;
      }).toList();
    });
  }

  @override
  List<PresencePlayer> getPresencePlayersByNames(List<String> names) {
    final List<PresencePlayer> presencePlayers = List.empty(growable: true);
    for (String playerName in names) {
      PresencePlayer? presencePlayer = getPlayerByName(playerName);
      presencePlayer ??= PresencePlayer.ghost(Player.ghost());
      presencePlayers.add(presencePlayer);
    }
    return presencePlayers;
  }
}