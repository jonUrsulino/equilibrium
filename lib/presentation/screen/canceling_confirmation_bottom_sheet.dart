import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/use_case/get_computed_confirmed_players_sort_by_name.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class CancelingConfirmationBottomSheet extends StatelessWidget {
  CancelingConfirmationBottomSheet({super.key});

  final repository = GetIt.I.get<PresencePlayerRepository>();
  final getComputedConfirmedPlayersSortByName = GetIt.I.get<GetComputedConfirmedPlayersSortByName>();

  @override
  Widget build(BuildContext context) {
    final confirmedPlayers = getComputedConfirmedPlayersSortByName.execute().watch(context);
    return Column(
      children: [
        Text(
          'Marque quem cancelou: ${confirmedPlayers.length}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: confirmedPlayers.length,
            itemBuilder: (context, index) {
              return PlayerTile(
                player: confirmedPlayers[index].player,
                arrived: false,
                onChangeArriving: (value) => onChangeCanceled(
                  confirmedPlayers[index],
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

  onChangeCanceled(PresencePlayer presencePlayer, value) {
    repository.playerCanceled(presencePlayer);
  }
}
