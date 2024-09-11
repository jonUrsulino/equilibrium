
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/member_team/presentation/member_team_widget.dart';
import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
  const TeamCard(Key? key, this.team, this.presencePlayerRepository): super(key: key);

  final Team team;
  final PresencePlayerRepository presencePlayerRepository;

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
          Text('${team.calculatePower()}',
            style: Theme
                .of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
          const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.star_border,
              color: Colors.white,
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
          var teamPresencePlayers = team.actualPresencePlayers(presencePlayerRepository);
          var presencePlayer = teamPresencePlayers[index];
          return MemberTeamWidget(
            Key(presencePlayer.player.name),
            presencePlayer: presencePlayer,
            position: (index + 1).toString(),
          );
        },
      ),
    );
  }

}