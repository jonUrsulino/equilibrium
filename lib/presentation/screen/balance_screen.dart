import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/team.dart';
import 'package:equilibrium/presentation/screen/member_team.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class BalanceScreen extends StatelessWidget {
  static const route = "BalanceScreen";

  const BalanceScreen({
    required this.coach,
    super.key,
  });

  final Coach coach;

  @override
  Widget build(BuildContext context) {
    final teams = coach.teams.watch(context);

    if (teams.isEmpty) {
      return _buildPresence();
    } else {
      return _buildTeams(context);
    }
  }

  Widget _buildPresence() {
    final arrivedPlayers = coach.presence.arrived.value;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: arrivedPlayers.length,
        itemBuilder: (context, index) {
          var presencePlayer = arrivedPlayers[index];
          return MemberTeam(
            position: (index + 1).toString(),
            presencePlayer: presencePlayer,
            arrived: true,
          );
        },
      ),
    );
  }

  Widget _buildTeams(BuildContext context) {
    final teams = coach.teams.watch(context);

    return Container(
      color: Colors.white10,
      child: ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context, index) {
            var team = teams[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _headerTeam(context, team),
                  _teamMembers(team),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    height: 1,
                  )
                ],
              ),
            );
          }),
    );
  }

  Container _teamMembers(Team team) {
    return Container(
      margin: const EdgeInsets.all(3),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: team.players.length,
        itemBuilder: (context, index) {
          var presencePlayer = team.players[index];
          return MemberTeam(
            position: (index + 1).toString(),
            presencePlayer: presencePlayer,
            arrived: true,
          );
        },
      ),
    );
  }

  Container _headerTeam(BuildContext context, Team team) {
    return Container(
      color: Theme.of(context).secondaryHeaderColor,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.shield,
              color: team.shirt.color,
            ),
          ),
          Text(
            team.shirt.name,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),
          const Spacer(),
          const Icon(
            Icons.star_border,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${team.calculatePower()}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
