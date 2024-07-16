import 'package:equilibrium/domain/home_arriving_player.dart';
import 'package:equilibrium/domain/player.dart';
import 'package:signals/signals.dart';

class PresencePlayers {
  final lastName = Signal('Equilibrium');

  //streaming
  final _registeredPlayers = ListSignal([
    HomeArrivingPlayer.initial(const Player("Jonathan", 4.0)),
    HomeArrivingPlayer.initial(const Player("Tiago", 5.0)),
    HomeArrivingPlayer.initial(const Player("Bino", 1.0)),
    HomeArrivingPlayer.initial(const Player("Danilo", 3.0)),
    HomeArrivingPlayer.initial(const Player("Edmilson", 2.0)),
    HomeArrivingPlayer.initial(const Player("Matias", 2.0)),
    HomeArrivingPlayer.initial(const Player("Rubens", 4.0)),
    HomeArrivingPlayer.initial(const Player("Silvano", 1.0)),
    HomeArrivingPlayer.initial(const Player("Kennedy", 4.0)),
    HomeArrivingPlayer.initial(const Player("Carlos", 3.0)),
    HomeArrivingPlayer.initial(const Player("Eli", 5.0)),
    HomeArrivingPlayer.initial(const Player("Phelip", 3.0)),
    HomeArrivingPlayer.initial(const Player("Henrique", 3.0)),
    HomeArrivingPlayer.initial(const Player("Ancelmo", 3.0)),
    HomeArrivingPlayer.initial(const Player("Breno", 4.0)),
    HomeArrivingPlayer.initial(const Player("Fabinho", 2.0)),
    HomeArrivingPlayer.initial(const Player("Motoca", 5.0)),
    HomeArrivingPlayer.initial(const Player("Mike", 3.0)),
    HomeArrivingPlayer.initial(const Player("Samuel", 3.0)),
    HomeArrivingPlayer.initial(const Player("Davi", 3.0)),
    HomeArrivingPlayer.initial(const Player("Adriano", 3.0)),
    HomeArrivingPlayer.initial(const Player("Haroldo", 1.0)),
  ]);

  // late final arrived = computed(() {
  //   return _registeredPlayers.value.where((e) => e.hasArrived).toList();
  // });
  late final ListSignal<HomeArrivingPlayer> arrived = ListSignal([]);
  late final ListSignal<HomeArrivingPlayer> arriving =
      ListSignal(_registeredPlayers);

  void playerArrived(Player player, bool value) {
    print('player arrived ${player.name}');

    var homeArrivingPlayer = _registeredPlayers.value
        .firstWhere((element) => element.player == player);

    var arrivedPlayer = homeArrivingPlayer.copyWith(player, value);

    arrived.add(arrivedPlayer);
    arriving.remove(homeArrivingPlayer);

    lastName.set(player.name);
  }

  void playerMissed(Player player, bool value) {
    print('player missed ${player.name}');

    var arrivedPlayer =
        arrived.value.firstWhere((element) => element.player == player);

    var missedPlayer = arrivedPlayer.copyWith(player, value);

    arrived.remove(arrivedPlayer);
    arriving.add(missedPlayer);

    lastName.set(player.name);
  }

  late final effecting = effect(() {
    print('${arrived.value.length}');
  });
}
