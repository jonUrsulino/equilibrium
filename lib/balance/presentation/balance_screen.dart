import 'package:equilibrium/balance/business/balance_bloc.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/member_team/presentation/member_team_widget.dart';
import 'package:equilibrium/presentation/screen/team_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signals/signals_flutter.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BalanceBloc bloc = context.read();

    return Watch((context) {
      final List<Team> teams = bloc.teamsSignal.watch(context);
      print('teams empty ${teams.isEmpty}');

      for (var team in teams) {
        print('team ${team.shirt.name}');
        for (var player in team.players) {
          print('team repository player ${player.name}');
        }
      }

      if (teams.isEmpty) {
        return _buildPresence(context);
      } else {
        return _buildTeams(context);
      }
    },);
  }

  Widget _buildPresence(BuildContext context) {
    final BalanceBloc bloc = context.read();
    final arrivedPlayers = bloc.arrivedPlayersSignals.watch(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: arrivedPlayers.length,
        itemBuilder: (context, index) {
          var presencePlayer = arrivedPlayers[index];
          return MemberTeamWidget(
            Key(presencePlayer.player.name),
            presencePlayer: presencePlayer,
            position: (index + 1).toString(),
          );
        },
      ),
    );
  }

  Widget _buildTeams(BuildContext context) {
    final BalanceBloc bloc = context.read();
    final ListSignal<Team> teams = bloc.teamsSignal.watch(context);

    return Container(
      color: Colors.white10,
      child: ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context, index) {
            var team = teams[index];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TeamCard(
                  Key(team.shirt.name),
                  team,
                  bloc.repository
              ),
            );
          }
      ),
    );
  }
}
