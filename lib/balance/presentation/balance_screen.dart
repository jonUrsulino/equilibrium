import 'package:equilibrium/balance/business/balance_bloc.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/model/shirt.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/member_team/presentation/member_team_widget.dart';
import 'package:equilibrium/presentation/screen/team_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signals/signals_flutter.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({required this.bloc, super.key});

  final BalanceBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceBloc, BalanceState>(
      builder: (context, state) {
        switch (state) {
          case BalanceInitialState():
            return const Center(
              child: CircularProgressIndicator(),
            );
          case NotBalancedState():
            return _buildPresence(state.teamPresencePlayers);
          case BalancedTeamsState():
            return _buildTeams(state.mapTeamsPresencePlayers);
        }
      },
    );
  }

  Widget _buildPresence(arrivedPlayers) {
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

  Widget _buildTeams(Map<Team, List<PresencePlayer>> teamsPresencePlayers) {
    return Container(
      color: Colors.white10,
      child: ListView.builder(
          itemCount: teamsPresencePlayers.length,
          itemBuilder: (context, index) {
            var team = teamsPresencePlayers.keys.toList()[index];
            List<PresencePlayer> presencePlayers = teamsPresencePlayers[team]!;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TeamCard(
                Key(team.shirt.name),
                team.shirt,
                presencePlayers,
                team.calculatePower(),
              ),
            );
          }
      ),
    );
  }
}
