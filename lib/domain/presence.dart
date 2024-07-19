import 'package:equilibrium/domain/home_arriving_player.dart';
import 'package:equilibrium/domain/player.dart';
import 'package:signals/signals.dart';

class PresencePlayers {
  final lastName = Signal('Equilibrium');

  //streaming
  final _registeredPlayers = ListSignal([
    HomeArrivingPlayer.initial(const Player("Eli", 5)),
    HomeArrivingPlayer.initial(const Player("Tiago Valadão", 5)),
    HomeArrivingPlayer.initial(const Player("Jonathan", 5)),
    HomeArrivingPlayer.initial(const Player("Jocivaldo", 4.5)),
    HomeArrivingPlayer.initial(const Player("Caio", 4.5)),
    HomeArrivingPlayer.initial(const Player("Kennedy", 4.5)),
    HomeArrivingPlayer.initial(const Player("Carlos", 4)),
    HomeArrivingPlayer.initial(const Player("Samuel", 4)),
    HomeArrivingPlayer.initial(const Player("Pr. Wilson", 4)),
    HomeArrivingPlayer.initial(const Player("Breno", 4)),
    HomeArrivingPlayer.initial(const Player("Rubens", 3)),
    HomeArrivingPlayer.initial(const Player("Danilo", 3)),
    HomeArrivingPlayer.initial(const Player("Diacono Marcos", 3)),
    HomeArrivingPlayer.initial(const Player("Henrique", 3)),
    HomeArrivingPlayer.initial(const Player("Phelip", 3)),
    HomeArrivingPlayer.initial(const Player("Alifer", 3)),
    HomeArrivingPlayer.initial(const Player("Diacono Edmilson", 3)),
    HomeArrivingPlayer.initial(const Player("Adriano", 2)),
    HomeArrivingPlayer.initial(const Player("Davi do Adriano", 2)),
    HomeArrivingPlayer.initial(const Player("Pr. Moacyr", 2)),
    HomeArrivingPlayer.initial(const Player("Gustavo", 2)),
    HomeArrivingPlayer.initial(const Player("Ancelmo", 2)),
    HomeArrivingPlayer.initial(const Player("Haroldo", 2)),
    HomeArrivingPlayer.initial(const Player("Samuelzinho", 1)),
    HomeArrivingPlayer.initial(const Player("Davi do Fabão", 1)),
    HomeArrivingPlayer.initial(const Player("Mike", 1)),
    HomeArrivingPlayer.initial(const Player("Silvano", 1)),
    HomeArrivingPlayer.initial(const Player("Fabinho", 1)),
    HomeArrivingPlayer.initial(const Player("Bino", 1)),
  ]);

  late final ListSignal<HomeArrivingPlayer> arrived = ListSignal([]);
  late final ListSignal<HomeArrivingPlayer> arriving =
      ListSignal(_registeredPlayers);

  void addNewPlayer(HomeArrivingPlayer value) {
    arriving.add(value);
  }

  void playerArrived(Player player, bool value) {
    print('player arrived ${player.name}');

    var homeArrivingPlayer = _registeredPlayers.value
        .firstWhere((element) => element.player == player);

    var arrivedPlayer =
        homeArrivingPlayer.copyWith(player, player.stars, value);

    arrived.add(arrivedPlayer);
    arriving.remove(homeArrivingPlayer);
  }

  void playerMissed(Player player, bool value) {
    print('player missed ${player.name}');

    var arrivedPlayer =
        arrived.value.firstWhere((element) => element.player == player);

    var missedPlayer = arrivedPlayer.copyWith(player, player.stars, value);

    arrived.remove(arrivedPlayer);
    arriving.add(missedPlayer);
  }

  late final effecting = effect(() {
    print('${arrived.value.length}');
  });
}
