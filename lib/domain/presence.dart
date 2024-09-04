import 'package:equilibrium/domain/home_arriving_player.dart';
import 'package:signals/signals.dart';

class PresencePlayers {
  PresencePlayers(this._listHomeArriving);

  final lastName = Signal('Equilibrium');

  //streaming
  final List<HomeArrivingPlayer> _listHomeArriving;

  final ListSignal<HomeArrivingPlayer> _arrived = ListSignal([]);
  final ListSignal<HomeArrivingPlayer> _promised = ListSignal([]);

  late final ListSignal<HomeArrivingPlayer> _arriving = ListSignal(_listHomeArriving);
  late final arrivingSortedByName = computed(() => _arriving.sorted(
        (a, b) => a.player.name.compareTo(b.player.name),
      ));

  late final promisedSortedByName = computed(() => _promised.sorted(
        (a, b) => a.player.name.compareTo(b.player.name),
      ));

  void addNewPlayer(HomeArrivingPlayer value) {
    _promised.add(value);
  }

  ListSignal<HomeArrivingPlayer> getArrivedWith(bool goalkeeper) {
    if (goalkeeper) {
      return _arrived;
    } else {
      return _arrived
          .where((element) => !element.player.isGoalkeeper)
          .toList()
          .toSignal();
    }
  }

  void playerArrived(HomeArrivingPlayer homeArrivingPlayer, bool value) {
    print('player arrived ${homeArrivingPlayer.player.name}');

    var changed = homeArrivingPlayer.copyWith(hasArrived: true);

    _arrived.add(changed);
    _promised.remove(homeArrivingPlayer);
    _arriving.remove(homeArrivingPlayer);
  }

  void playerPromised(HomeArrivingPlayer homeArrivingPlayer, bool value) {
    print('player promised ${homeArrivingPlayer.player.name}');

    _promised.add(homeArrivingPlayer);
    _arrived.remove(homeArrivingPlayer);
    _arriving.remove(homeArrivingPlayer);
  }

  void playerMissed(HomeArrivingPlayer homeArrivingPlayer, bool value) {
    print('player missed ${homeArrivingPlayer.player.name}');

    var changed = homeArrivingPlayer.copyWith(hasArrived: false);

    _promised.add(changed);
    _arrived.remove(homeArrivingPlayer);
    _arriving.remove(homeArrivingPlayer);
  }

  void playerCanceled(HomeArrivingPlayer homeArrivingPlayer) {
    print('player canceled ${homeArrivingPlayer.player.name}');

    _arriving.add(homeArrivingPlayer);
    _arrived.remove(homeArrivingPlayer);
    _promised.remove(homeArrivingPlayer);
  }

  late final effecting = effect(() {
    print('${_arrived.value.length}');
  });

  // List<HomeArrivingPlayer> getPlayers() {
  //   return _useCase.execute().toFutureSignal().requireValue;
  // }
}
