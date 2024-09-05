import 'package:equilibrium/domain/controller_manager.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:equilibrium/domain/team.dart';
import 'package:equilibrium/presentation/screen/member_team.dart';
import 'package:equilibrium/presentation/screen/team_card.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class GameScreen extends StatelessWidget {

  const GameScreen({
    required this.controller,
    super.key,
  });

  final ControllerManager controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
          children: [
            _buildCardGame(context),
            const Padding(
                padding: EdgeInsets.all(8),
                child: Text('Próximos')
            ),
            _nextTeams(context)
          ]
      ),
    );
  }

  Widget _buildCardGame(BuildContext context) {
    return Watch((context) {
      var game = controller.managerGame?.game.watch(context);

      if (game != null) {
        final teamA = game.teamA;
        final teamB = game.teamB;
        print('card teamA: ${teamA.shirt.name}');
        print('card teamB: ${teamB.shirt.name}');

        return Card(
          shape: const RoundedRectangleBorder(),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              color: Colors.white10,
              child: Row(
                children: [
                  _buildTeam(context, teamA, SideTeam.teamA),
                  _buildTeam(context, teamB, SideTeam.teamB)
                ],
              ),
            ),
          ),
        );
      } else {
        return const Text('Game not created');
      }
    });
  }

  Widget _buildTeam(BuildContext context, Team teammm, SideTeam sideTeam) {
    Team team;
    switch (sideTeam) {
      case SideTeam.teamA:
        team = controller.teamA.watch(context);
      case SideTeam.teamB:
      default:
        team = controller.teamB.watch(context);
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _headerTeam(context, team),
            _teamMembers(team),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () => onRemoveTeam(team, sideTeam),
              child: const Text('Perdeu'),
            )
          ],
        ),
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
          var homeArrivingPlayer = team.players[index];
          return MemberTeam(
            position: (index + 1).toString(),
            homeArrivingPlayer: homeArrivingPlayer,
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

  Widget _nextTeams(BuildContext context) {
    final teams = controller.nextTeams.watch(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: teams.length,
          itemBuilder: (context, index) {
            var team = teams[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TeamCard(team),
            );
          }),
    );
  }

  onRemoveTeam(Team team, SideTeam sideTeam) {
    print('onRemoveTeam ${team.shirt.name} $sideTeam');
    controller.changeTeam(team, sideTeam);
  }
}

enum SideTeam {
  teamA, teamB
}