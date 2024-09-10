import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:signals/signals.dart';

part 'raffle_players_event.dart';
part 'raffle_players_state.dart';

class RafflePlayersBloc extends Bloc<RafflePlayersEvent, RafflePlayersState> {
  RafflePlayersBloc() : super(RafflePlayersInitial()) {
    on<RafflePlayersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final PresencePlayerRepository repository = GetIt.I.get();

  late final arrivedPlayersSignal = repository.getComputedArrivedPresencePlayers();

  final ListSignal<Player> markedPlayers = ListSignal([]);

  final ListSignal<Player> sortedPlayers = ListSignal([]);

  final ListSignal<Player> arrivedPlayers = ListSignal([]);

  var luckyPlayersAmount = signal(3);

  var isSorted = signal(false);

  decMaxPlayersByTeam() {
    luckyPlayersAmount.set(luckyPlayersAmount.value - 1);
  }

  incMaxPlayersByTeam() {
    luckyPlayersAmount.set(luckyPlayersAmount.value + 1);
  }

  onTapRaffle() {
    sortedPlayers.clear();
    var random = Random();

    while(sortedPlayers.length < luckyPlayersAmount.value) {
      var numberRandomized = random.nextInt(markedPlayers.value.length);

      var unluckyPlayer = markedPlayers.value[numberRandomized];
      markedPlayers.remove(unluckyPlayer);

      sortedPlayers.add(unluckyPlayer);
      print('Unlucky: ${unluckyPlayer.name}');

      if (markedPlayers.isEmpty) {
        break;
      }
    }
    isSorted.value = true;
  }

  onTapClean() {
    markedPlayers.clear();
    isSorted.value = false;
  }
}
