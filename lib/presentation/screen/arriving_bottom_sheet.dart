import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/use_case/get_computed_confirmed_players_sort_by_name.dart';
import 'package:equilibrium/domain/use_case/get_computed_presence_players_sorted_by_name.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class ArrivingBottomSheet extends StatelessWidget {
  ArrivingBottomSheet({super.key});

  final PresencePlayerRepository presencePlayerRepository = GetIt.I.get();
  final getComputedPresencePlayersSortedByName = GetIt.I.get<GetComputedPresencePlayersSortedByName>();
  final getConfirmedPlayersSortByName = GetIt.I.get<GetComputedConfirmedPlayersSortByName>();

  @override
  Widget build(BuildContext context) {
    final initialPlayers = getComputedPresencePlayersSortedByName.execute().watch(context);
    return Column(
      children: [
        Text(
          'Marque os confirmados: ${getConfirmedPlayersSortByName.execute().watch(context).length}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: initialPlayers.length,
            itemBuilder: (context, index) {
              return PlayerTile(
                player:
                    initialPlayers[index].player,
                arrived: false,
                onChangeArriving: (value) => onChangeConfirmed(
                  initialPlayers[index],
                  value,
                ),
                showStars: false,
              );
            },
          ),
        )
      ],
    );
  }

  onChangeConfirmed(PresencePlayer presencePlayer, value) {
    presencePlayerRepository.playerConfirmed(presencePlayer, value);
  }
}
