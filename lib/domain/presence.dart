import 'package:equilibrium/domain/home_arriving_player.dart';
import 'package:equilibrium/domain/player.dart';
import 'package:signals/signals.dart';

class PresencePlayers {
  final lastName = Signal('Equilibrium');

  //streaming
  final List<HomeArrivingPlayer> _listHomeArriving = [
    HomeArrivingPlayer.initial(Player.normal("Eli", 5)),
    HomeArrivingPlayer.initial(Player.normal("Tiago Valadão", 5)),
    HomeArrivingPlayer.initial(Player.normal("Jonathan", 5)),
    HomeArrivingPlayer.initial(Player.normal("Jocivaldo", 4.5)),
    HomeArrivingPlayer.initial(Player.normal("Caio", 4.5)),
    HomeArrivingPlayer.initial(Player.normal("Kennedy", 4.5)),
    HomeArrivingPlayer.initial(Player.normal("Carlos", 4)),
    HomeArrivingPlayer.initial(Player.normal("Samuel", 4)),
    HomeArrivingPlayer.initial(Player.normal("Pr. Wilson", 4)),
    HomeArrivingPlayer.initial(Player.normal("Breno", 4)),
    HomeArrivingPlayer.initial(Player.normal("Rubens", 3)),
    HomeArrivingPlayer.initial(Player.normal("Danilo", 3)),
    HomeArrivingPlayer.initial(Player.normal("Diacono Marcos", 3)),
    HomeArrivingPlayer.initial(Player.normal("Henrique", 3)),
    HomeArrivingPlayer.initial(Player.normal("Phelip", 3)),
    HomeArrivingPlayer.initial(Player.normal("Alifer", 3)),
    HomeArrivingPlayer.initial(Player.normal("Diacono Edmilson", 3)),
    HomeArrivingPlayer.initial(Player.normal("Adriano", 2)),
    HomeArrivingPlayer.initial(Player.normal("Davi do Adriano", 2)),
    HomeArrivingPlayer.initial(Player.normal("Pr. Moacyr", 2)),
    HomeArrivingPlayer.initial(Player.normal("Gustavo", 2)),
    HomeArrivingPlayer.initial(Player.normal("Ancelmo", 2)),
    HomeArrivingPlayer.initial(Player.normal("Haroldo", 2)),
    HomeArrivingPlayer.initial(Player.normal("Samuelzinho", 1)),
    HomeArrivingPlayer.initial(Player.normal("Davi do Fabão", 1)),
    HomeArrivingPlayer.initial(Player.normal("Mike", 1)),
    HomeArrivingPlayer.initial(Player.normal("Silvano", 1)),
    HomeArrivingPlayer.initial(Player.normal("Fabinho", 1)),
    HomeArrivingPlayer.initial(Player.normal("Bino", 1)),
    HomeArrivingPlayer.initial(Player.goalkeeper("Fabão", 2)),
    HomeArrivingPlayer.initial(Player.goalkeeper("Amigo Danilo", 4)),
  ]..sort((a, b) => a.player.name.compareTo(b.player.name));

  late final ListSignal<HomeArrivingPlayer> arrived = ListSignal([]);

  late final ListSignal<HomeArrivingPlayer> _arriving =
      ListSignal(_listHomeArriving);
  late final sortedArriving = computed(() => _arriving.sorted(
        (a, b) => a.player.name.compareTo(b.player.name),
      ));

  void addNewPlayer(HomeArrivingPlayer value) {
    _arriving.add(value);
  }

  ListSignal<HomeArrivingPlayer> getArrivedWith(bool goalkeeper) {
    if (goalkeeper) {
      return arrived;
    } else {
      return arrived
          .where((element) => !element.player.isGoalkeeper)
          .toList()
          .toSignal();
    }
  }

  void playerArrived(Player player, bool value) {
    print('player arrived ${player.name}');

    var homeArrivingPlayer =
        _listHomeArriving.firstWhere((element) => element.player == player);

    var arrivedPlayer =
        homeArrivingPlayer.copyWith(player, player.stars, value);

    arrived.add(arrivedPlayer);
    _arriving.remove(homeArrivingPlayer);
  }

  void playerMissed(Player player, bool value) {
    print('player missed ${player.name}');

    var arrivedPlayer =
        arrived.value.firstWhere((element) => element.player == player);

    var missedPlayer = arrivedPlayer.copyWith(player, player.stars, value);

    arrived.remove(arrivedPlayer);
    _arriving.add(missedPlayer);
  }

  late final effecting = effect(() {
    print('${arrived.value.length}');
  });
}
