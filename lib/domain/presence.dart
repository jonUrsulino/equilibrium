import 'package:equilibrium/domain/home_arriving_player.dart';
import 'package:equilibrium/domain/player.dart';
import 'package:signals/signals.dart';

class PresencePlayers {
  final lastName = Signal('Equilibrium');

  //streaming
  final List<HomeArrivingPlayer> _listHomeArriving = [
    HomeArrivingPlayer.initial(Player.normal("Tiago Valadão", 5)),
    HomeArrivingPlayer.initial(Player.normal("Jocivaldo", 5)),
    HomeArrivingPlayer.initial(Player.normal("Eli", 5)),
    HomeArrivingPlayer.initial(Player.normal("Jonathan", 5)),
    HomeArrivingPlayer.initial(Player.normal("Caio", 4.5)),
    HomeArrivingPlayer.initial(Player.normal("Kennedy", 4.5)),
    HomeArrivingPlayer.initial(Player.normal("Samuel", 4.5)),
    HomeArrivingPlayer.initial(Player.goalkeeper("Murilo", 4.5)),
    HomeArrivingPlayer.initial(Player.normal("Pr. Wilson", 4)),
    HomeArrivingPlayer.initial(Player.normal("Breno", 4)),
    HomeArrivingPlayer.initial(Player.normal("Rubens", 4)),
    HomeArrivingPlayer.initial(Player.normal("Carlos", 4)),
    HomeArrivingPlayer.initial(Player.normal("Danilo", 3.5)),
    HomeArrivingPlayer.initial(Player.normal("Marcos", 3.5)),
    HomeArrivingPlayer.initial(Player.normal("Henrique", 3.5)),
    HomeArrivingPlayer.initial(Player.normal("Phelip", 3.5)),
    HomeArrivingPlayer.initial(Player.normal("Alifer", 3.5)),
    HomeArrivingPlayer.initial(Player.normal("Edmilson", 3)),
    HomeArrivingPlayer.initial(Player.normal("Pr. Moacyr", 3)),
    HomeArrivingPlayer.initial(Player.normal("Ancelmo", 3)),
    HomeArrivingPlayer.initial(Player.normal("Samuelzinho", 3)),
    HomeArrivingPlayer.initial(Player.goalkeeper("Fabão", 2.5)),
    HomeArrivingPlayer.initial(Player.normal("Adriano Bispo", 2.5)),
    HomeArrivingPlayer.initial(Player.normal("Gustavo", 2.5)),
    HomeArrivingPlayer.initial(Player.normal("Mike", 2)),
    HomeArrivingPlayer.initial(Player.normal("Davi Bispo", 2)),
    HomeArrivingPlayer.initial(Player.normal("Haroldo", 2)),
    HomeArrivingPlayer.initial(Player.normal("Rafa", 2)),
    HomeArrivingPlayer.initial(Player.normal("Silvano", 1.5)),
    HomeArrivingPlayer.initial(Player.normal("Fabinho", 1.5)),
    HomeArrivingPlayer.initial(Player.normal("Bino", 1.5)),
    HomeArrivingPlayer.initial(Player.normal("Davizinho", 1.5)),
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

  void playerArrived(Player player, bool value) {
    print('player arrived ${player.name}');

    var homeArrivingPlayer = HomeArrivingPlayer(player);

    _arrived.add(homeArrivingPlayer);
    _promised.remove(homeArrivingPlayer);
    _arriving.remove(homeArrivingPlayer);
  }

  void playerPromised(Player player, bool value) {
    print('player promised ${player.name}');

    var homeArrivingPlayer = HomeArrivingPlayer(player);

    _promised.add(homeArrivingPlayer);
    _arrived.remove(homeArrivingPlayer);
    _arriving.remove(homeArrivingPlayer);
  }

  void playerMissed(Player player, bool value) {
    print('player missed ${player.name}');

    var missedPlayer = HomeArrivingPlayer(player);

    _promised.add(missedPlayer);
    _arrived.remove(missedPlayer);
    _arriving.remove(missedPlayer);
  }

  void playerCanceled(Player player) {
    print('player canceled ${player.name}');

    var canceledPlayer = HomeArrivingPlayer(player);

    _arriving.add(canceledPlayer);
    _arrived.remove(canceledPlayer);
    _promised.remove(canceledPlayer);
  }

  late final effecting = effect(() {
    print('${_arrived.value.length}');
  });
}
