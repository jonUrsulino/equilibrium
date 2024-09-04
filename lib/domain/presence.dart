import 'package:equilibrium/domain/home_arriving_player.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';

class PresencePlayers {
  PresencePlayers(this._listHomeArriving);

  final lastName = Signal('Equilibrium');

  //streaming
  final Map<String, HomeArrivingPlayer> _listHomeArriving;

  late final MapSignal<String, HomeArrivingPlayer> _arriving = MapSignal(_listHomeArriving);
  late final arrived = computed<List<HomeArrivingPlayer>>(() => _arriving.values.where((element) => element.statePresence == StatePresence.arrived).toList());
  late final _promised = computed<List<HomeArrivingPlayer>>(() => _arriving.values.where((element) => element.statePresence == StatePresence.confirmed).toList());

  late final initialSortedByName = computed<List<HomeArrivingPlayer>>(() => _arriving.values
      .where((element) => element.statePresence == StatePresence.initial).toList()..sort(
          (a, b) => a.player.name.compareTo(b.player.name),
  ));

  late final promisedSortedByName = computed<List<HomeArrivingPlayer>>(() => _promised.value.toList()..sort(
        (a, b) => a.player.name.compareTo(b.player.name),
      ));

  late final arrivedWithoutGoalkeeper = computed<List<HomeArrivingPlayer>>(() => arrived.value.where((element) => !element.player.isGoalkeeper).toList());

  void addNewPlayer(HomeArrivingPlayer value) {
    _arriving[value.player.name] = value;
  }

  ListSignal<HomeArrivingPlayer> getArrivedWith(bool goalkeeper) {
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

  void playerArrived(HomeArrivingPlayer homeArrivingPlayer, bool value) {
    print('player arrived ${homeArrivingPlayer.player.name}');

    var changed = homeArrivingPlayer.copyWith(statePresence: StatePresence.arrived);
    _arriving[homeArrivingPlayer.player.name] = changed;
  }

  void playerPromised(HomeArrivingPlayer homeArrivingPlayer, bool value) {
    print('player promised ${homeArrivingPlayer.player.name}');

    var changed = homeArrivingPlayer.copyWith(statePresence: StatePresence.confirmed);
    _arriving[homeArrivingPlayer.player.name] = changed;
  }

  void playerMissed(HomeArrivingPlayer homeArrivingPlayer, bool value) {
    print('player missed ${homeArrivingPlayer.player.name}');

    var changed = homeArrivingPlayer.copyWith(statePresence: StatePresence.confirmed);
    _arriving[homeArrivingPlayer.player.name] = changed;
  }

  void playerCanceled(HomeArrivingPlayer homeArrivingPlayer) {
    print('player canceled ${homeArrivingPlayer.player.name}');

    var changed = homeArrivingPlayer.copyWith(statePresence: StatePresence.initial);
    _arriving[homeArrivingPlayer.player.name] = changed;
  }

  late final effecting = effect(() {
    print('${arrived.value.length}');
  });
}
