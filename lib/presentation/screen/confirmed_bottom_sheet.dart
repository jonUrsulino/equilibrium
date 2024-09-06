import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/use_case/get_computed_confirmed_players_sort_by_name.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class ConfirmedBottomSheet extends StatelessWidget {
  ConfirmedBottomSheet({super.key});

  final repository = GetIt.I.get<PresencePlayerRepository>();
  final getComputedConfirmedPlayersSortByName = GetIt.I.get<GetComputedConfirmedPlayersSortByName>();

  @override
  Widget build(BuildContext context) {
    final confirmedPlayersList = getComputedConfirmedPlayersSortByName.execute().watch(context);
    return Column(
      children: [
        Text(
          'Confirme quem já chegou',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: confirmedPlayersList.length,
            itemBuilder: (context, index) {
              var presencePlayer = confirmedPlayersList[index];
              return PlayerTile(
                  player: presencePlayer.player,
                  arrived: false,
                  onChangeArriving: (value) => onChangeArriving(
                    presencePlayer,
                    value,
                  ),
                  showStars: true,
              );
            },
          ),
        )
      ],
    );
  }

  onChangeArriving(PresencePlayer presencePlayer, value) {
    repository.playerArrived(presencePlayer, value);
  }

  onChangeCanceled(PresencePlayer presencePlayer) {
    repository.playerCanceled(presencePlayer);
  }
}
