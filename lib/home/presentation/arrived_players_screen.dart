
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/home/business_logic/arrived_players_bloc.dart';
import 'package:equilibrium/presentation/screen/player_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArrivedPlayersScreen extends StatelessWidget {
  const ArrivedPlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ArrivedPlayersBloc bloc = context.read();
    final Stream<List<PresencePlayer>> streamArrivedPlayers = bloc.arrivedPlayersStream;

    return StreamBuilder<List<PresencePlayer>>(
        stream: streamArrivedPlayers,
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Container();
          }

          List<PresencePlayer> homeArrived = snapshot.requireData;
          final length = homeArrived.length;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: length,
                    itemBuilder: (context, index) {
                      var homeArrivedPlayer = homeArrived[index];
                      return PlayerTile(
                        player: homeArrivedPlayer.player,
                        arrived: true,
                        onChangeArriving: (value) => onChangeMissing(
                          bloc,
                          homeArrivedPlayer,
                          value,
                        ),
                        showStars: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  onChangeMissing(ArrivedPlayersBloc bloc, PresencePlayer presencePlayer, value) {
    bloc.repository.playerMissed(presencePlayer, value);
  }

}