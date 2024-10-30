import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:equilibrium/raffle_players/business_logic/raffle_players_bloc.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class RafflePlayersComponent extends StatelessWidget {
  RafflePlayersComponent({
    required this.bloc,
    super.key
  });

  final RafflePlayersBloc bloc;

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Container(
        color: bloc.isSorted.watch(context) ? Colors.green : Colors.white,
        child: StreamBuilder<List<PresencePlayer>>(
          stream: bloc.arrivedPlayersStream,
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return Container();
            }
            final arrived = snapshot.requireData;

            return Column(
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
                      child: Watch((context) {
                        final list = bloc.isSorted.value ? bloc.sortedPlayers.value : bloc.markedPlayers.value;
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            var player = list[index];
                            return PlayerTile(
                              player: player,
                              arrived: true,
                              onChangeArriving: (value) =>
                                  onMarkPlayer(
                                    player,
                                    value,
                                  ),
                              showStars: false,
                            );
                          },
                        );
                      }),
                    ),
                  ],
                )
              ],
            );
          }
        ),
      ),
    );
  }

  onMarkPlayer(Player player, value) {
    if (value) {
      if (!bloc.markedPlayers.contains(player)) {
        bloc.markedPlayers.add(player);
      }
    } else {
      bloc.markedPlayers.remove(player);
    }
  }

  Widget buildRowButtons(BuildContext context) {
    return Row(
        children: [
          Expanded(child: TextButton(onPressed: () => bloc.onTapRaffle(), child: const Text('Sortear'))),
          Expanded(child: TextButton(onPressed: () => bloc.onTapClean(), child: const Text('Limpar')))
        ]
    );
  }

  Widget buildRowDecInc(BuildContext context) {
    return Row(
      children: [
        Text(
          'Manter ${bloc.luckyPlayersAmount} jogadores:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        IconButton(
          onPressed: () => bloc.decMaxPlayersByTeam(),
          icon: const Icon(
            Icons.exposure_minus_1,
          ),
        ),
        Text(
          '${bloc.luckyPlayersAmount.watch(context)}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        IconButton(
          onPressed: () => bloc.incMaxPlayersByTeam(),
          icon: const Icon(
            Icons.exposure_plus_1,
          ),
        ),
      ],
    );
  }


}

