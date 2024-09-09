import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/home/business_logic/confirmed_players_bloc.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signals/signals_flutter.dart';

class ConfirmedBottomSheet extends StatelessWidget {
  const ConfirmedBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfirmedPlayersBloc bloc = context.read();
    final confirmedPlayersList = bloc.getComputedConfirmedPlayersSortByName.execute().watch(context);
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
                    bloc,
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

  onChangeArriving(ConfirmedPlayersBloc bloc, PresencePlayer presencePlayer, value) {
    bloc.repository.playerArrived(presencePlayer, value);
  }
}
