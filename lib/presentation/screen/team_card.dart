
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/member_team/presentation/member_team_component.dart';
import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
  const TeamCard(this.team, {super.key});

  final Team team;

  @override
  Widget build(BuildContext context) {

    return Column(
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

  Container _teamMembers(Team team) {
    return Container(
      margin: const EdgeInsets.all(3),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: team.players.length,
        itemBuilder: (context, index) {
          var presencePlayer = team.players[index];
          return MemberTeamComponent(
            playerName: presencePlayer.player.name,
            position: (index + 1).toString(),
          );
        },
      ),
    );
  }

}