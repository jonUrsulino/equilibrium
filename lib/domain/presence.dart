import 'package:equilibrium/domain/presence_player.dart';
import 'package:signals/signals.dart';

class PresencePlayers {
  PresencePlayers(this._initialPresencePlayers);

  final lastName = Signal('Equilibrium');

  //streaming
  final Map<String, PresencePlayer> _initialPresencePlayers;

  late final MapSignal<String, PresencePlayer> _arriving = MapSignal(_initialPresencePlayers);
  late final arrived = computed<List<PresencePlayer>>(() => _arriving.values.where((element) => element.statePresence == StatePresence.arrived).toList());
  late final _confirmed = computed<List<PresencePlayer>>(() => _arriving.values.where((element) => element.statePresence == StatePresence.confirmed).toList());

  late final initialSortedByName = computed<List<PresencePlayer>>(() => _arriving.values
      .where((element) => element.statePresence == StatePresence.initial).toList()..sort(
          (a, b) => a.player.name.compareTo(b.player.name),
  ));

  late final confirmedSortedByName = computed<List<PresencePlayer>>(() => _confirmed.value.toList()..sort(
        (a, b) => a.player.name.compareTo(b.player.name),
      ));

  late final arrivedWithoutGoalkeeper = computed<List<PresencePlayer>>(() => arrived.value.where((element) => !element.player.isGoalkeeper).toList());

  void addNewPlayer(PresencePlayer value) {
    _arriving[value.player.name] = value;
  }

  ListSignal<PresencePlayer> getArrivedWith(bool goalkeeper) {
    if (goalkeeper) {
      return arrived.value.toSignal();
    } else {
      return arrived
          .value
          .where((element) => !element.player.isGoalkeeper)
          .toList()
          .toSignal();
    }
  }

  void playerArrived(PresencePlayer presencePlayer, bool value) {
    print('player arrived ${presencePlayer.player.name}');

    var changed = presencePlayer.copyWith(statePresence: StatePresence.arrived);
    _arriving[presencePlayer.player.name] = changed;
  }

  void playerConfirmed(PresencePlayer presencePlayer, bool value) {
    print('player promised ${presencePlayer.player.name}');

    var changed = presencePlayer.copyWith(statePresence: StatePresence.confirmed);
    _arriving[presencePlayer.player.name] = changed;
  }

  void playerMissed(PresencePlayer presencePlayer, bool value) {
    print('player missed ${presencePlayer.player.name}');

    var changed = presencePlayer.copyWith(statePresence: StatePresence.confirmed);
    _arriving[presencePlayer.player.name] = changed;
  }

  void playerCanceled(PresencePlayer presencePlayer) {
    print('player canceled ${presencePlayer.player.name}');

    var changed = presencePlayer.copyWith(statePresence: StatePresence.initial);
    _arriving[presencePlayer.player.name] = changed;
  }

  late final effecting = effect(() {
    print('${arrived.value.length}');
  });
}
