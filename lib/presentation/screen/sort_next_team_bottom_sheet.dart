import 'dart:math';

import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class SortNextTeamBottomSheet extends StatelessWidget {
  SortNextTeamBottomSheet({super.key});

  final presence = GetIt.I.get<PresencePlayers>();

  final ListSignal<Player> markedPlayers = ListSignal([]);
  final ListSignal<String> sortedPlayers = ListSignal([]);
  final ListSignal<Player> arrivedPlayers = ListSignal([]);
  final unluckyNumber = Signal(3);
  final textController = TextEditingController();

  var numberToSortUnlucky = signal(3);
  var isSorted = signal(false);

  @override
  Widget build(BuildContext context) {
    final arrived = presence.arrived.watch(context);
    final marked = markedPlayers.watch(context);

    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Container(
        color: isSorted.watch(context) ? Colors.green : Colors.white,
        child: Column(
          children: [
            Text(
              'Sortear jogadores:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            buildRowDecInc(context),
            buildRowButtons(context),
            Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: arrived.length,
                    itemBuilder: (context, index) {
                      var player = arrived[index];
                      return PlayerTile(
                        player: player.player,
                        arrived: false,
                        onChangeArriving: (value) => onMarkPlayer(
                          player.player,
                          value,
                        ),
                        showStars: false,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: marked.length,
                    itemBuilder: (context, index) {
                      var player = marked[index];
                      return PlayerTile(
                        player: player,
                        arrived: true,
                        onChangeArriving: (value) => onMarkPlayer(
                          player,
                          value,
                        ),
                        showStars: false,
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  onMarkPlayer(Player player, value) {
    if (value) {
      if (!markedPlayers.contains(player)) {
        markedPlayers.add(player);
      }
    } else {
      markedPlayers.remove(player);
    }
  }

  Widget buildRowButtons(BuildContext context) {
    return Row(
        children: [
          Expanded(child: TextButton(onPressed: () => _onTapSort(), child: const Text('Sortear'))),
          Expanded(child: TextButton(onPressed: () => _onTapClean(), child: const Text('Limpar')))
        ]
    );
  }

  Widget buildRowDecInc(BuildContext context) {
    return Row(
      children: [
        Text(
          'Retirar $numberToSortUnlucky jogadores:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        IconButton(
          onPressed: () => decMaxPlayersByTeam(),
          icon: const Icon(
            Icons.exposure_minus_1,
          ),
        ),
        Text(
          '${numberToSortUnlucky.watch(context)}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        IconButton(
          onPressed: () => incMaxPlayersByTeam(),
          icon: const Icon(
            Icons.exposure_plus_1,
          ),
        ),
      ],
    );
  }

  decMaxPlayersByTeam() {
    numberToSortUnlucky.set(numberToSortUnlucky.value - 1);
  }

  incMaxPlayersByTeam() {
    numberToSortUnlucky.set(numberToSortUnlucky.value + 1);
  }

  _onTapSort() {
    var random = Random();
    for (int i = 0; i < numberToSortUnlucky.value; i++) {
      // Value is >= 0 and < presence.players.length
      var numberRandomized = random.nextInt(markedPlayers.value.length);

      var unluckyPlayer = markedPlayers.value[numberRandomized];
      markedPlayers.remove(unluckyPlayer);
      print('Unlucky: ${unluckyPlayer.name}');

      // team.addPlayer(unluckyPlayer);
    }
    isSorted.value = true;
  }

  _onTapClean() {
    markedPlayers.clear();
    isSorted.value = false;
  }
}

