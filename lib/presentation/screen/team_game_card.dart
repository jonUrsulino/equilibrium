

import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/game/presentation/game_card.dart';
import 'package:equilibrium/member_team/presentation/member_team_widget.dart';
import 'package:flutter/material.dart';

class TeamGameCard extends StatelessWidget {
  const TeamGameCard({
    required this.team,
    required this.sideTeam,
    required this.function,
    required this.presencePlayerRepository,
    super.key,
  });

  final Team team;
  final SideTeam sideTeam;
  final Function function;
  final PresencePlayerRepository presencePlayerRepository;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _headerTeam(context, team, sideTeam),
            _teamMembers(context, team, sideTeam),
          ],
        ),
      ),
    );
  }

  Widget _headerTeam(BuildContext context, Team team, SideTeam sideTeam) {
    return Container(
      color: Theme
          .of(context)
          .secondaryHeaderColor,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              Icons.shield,
              color: team.shirt.color,
            ),
          ),
          Text(
            team.shirt.name,
            style: Theme
                .of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
          IconButton(
            onPressed: () => onRemoveTeam(team, sideTeam),
            icon: const Icon(Icons.move_down),
            color: Colors.white,
            tooltip: "Perdeu",
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

  Widget _teamMembers(BuildContext context, Team team, SideTeam sideTeam) {
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
            position: "${index + 1}",
            starsVisibility: false,
          );
        },
      ),
    );
  }

  onRemoveTeam(Team team, SideTeam sideTeam) {
    print('onRemoveTeam ${team.shirt.name}');
    function(team, sideTeam);
  }
}