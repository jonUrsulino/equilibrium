import 'package:equilibrium/domain/home_arriving_player.dart';
import 'package:equilibrium/domain/player.dart';
import 'package:signals/signals.dart';

class PresencePlayers {
  final lastName = Signal('Equilibrium');

  //streaming
  final List<HomeArrivingPlayer> _listHomeArriving = [
    HomeArrivingPlayer.initial(Player.normal("Tiago Valadão", 5)),
    HomeArrivingPlayer.initial(Player.normal("Jocivaldo", 5)),
    HomeArrivingPlayer.initial(Player.normal("Jonathan", 5)),
    HomeArrivingPlayer.initial(Player.normal("Eli", 5)),
    HomeArrivingPlayer.initial(Player.normal("Samuel", 4.5)),
    HomeArrivingPlayer.initial(Player.normal("Caio", 4.5)),
    HomeArrivingPlayer.initial(Player.normal("Kennedy", 4.5)),
    HomeArrivingPlayer.initial(Player.goalkeeper("Murilo", 4.5)),
    HomeArrivingPlayer.initial(Player.normal("Pr. Wilson", 4)),
    HomeArrivingPlayer.initial(Player.normal("Breno", 4)),
    HomeArrivingPlayer.initial(Player.normal("Rubens", 4)),
    HomeArrivingPlayer.initial(Player.normal("Carlos", 4)),
    HomeArrivingPlayer.initial(Player.normal("Danilo", 3.5)),
    HomeArrivingPlayer.initial(Player.normal("Marcos", 3.5)),
    HomeArrivingPlayer.initial(Player.normal("Henrique", 3.5)),
    HomeArrivingPlayer.initial(Player.normal("Alifer", 3.5)),
    HomeArrivingPlayer.initial(Player.normal("Phelip", 3)),
    HomeArrivingPlayer.initial(Player.normal("Edmilson", 3)),
    HomeArrivingPlayer.initial(Player.normal("Davi Bispo", 3)),
    HomeArrivingPlayer.initial(Player.normal("Pr. Moacyr", 2.5)),
    HomeArrivingPlayer.initial(Player.normal("Ancelmo", 2.5)),
    HomeArrivingPlayer.initial(Player.goalkeeper("Fabio Benatti", 2.5)),
    HomeArrivingPlayer.initial(Player.normal("Adriano Bispo", 2.5)),
    HomeArrivingPlayer.initial(Player.normal("Mike", 2)),
    HomeArrivingPlayer.initial(Player.normal("Gustavo", 2)),
    HomeArrivingPlayer.initial(Player.normal("Samuelzinho", 2)),
    HomeArrivingPlayer.initial(Player.normal("Davi Benatti", 2)),
    HomeArrivingPlayer.initial(Player.normal("Rafa", 1.5)),
    HomeArrivingPlayer.initial(Player.normal("Haroldo", 1.5)),
    HomeArrivingPlayer.initial(Player.normal("Kevin", 1.5)),
    HomeArrivingPlayer.initial(Player.normal("Fabinho", 1.0)),
    HomeArrivingPlayer.initial(Player.normal("Pr. Silvano", 1.0)),
    HomeArrivingPlayer.initial(Player.normal("Bino", 1.0)),
  ]..sort((a, b) => a.player.name.compareTo(b.player.name));

  final ListSignal<HomeArrivingPlayer> _arrived = ListSignal([]);
  final ListSignal<HomeArrivingPlayer> _promised = ListSignal([]);

  late final ListSignal<HomeArrivingPlayer> _arriving =
      ListSignal(_listHomeArriving);
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
}
