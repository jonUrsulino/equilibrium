import 'package:equilibrium/domain/controller_manager.dart';
import 'package:equilibrium/domain/team.dart';
import 'package:equilibrium/presentation/screen/member_team.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {

  const GameScreen({
    required this.controller,
    super.key,
  });

  final ControllerManager controller;

  @override
  Widget build(BuildContext context) {
    return _buildTeams(context);
  }

  Widget _buildTeams(BuildContext context) {
    var game = controller.managerGame?.game;

    if (game != null) {
      final teamA = game.teamA;
      final teamB = game.teamB;

      return Container(
        color: Colors.white10,
        child: Row(
          children: [
            _buildTeam(context, teamA),
            _buildTeam(context, teamB)
          ],
        ),
      );
    } else {
      return const Text('Game not created');
    }
  }

  Widget _buildTeam(BuildContext context, Team team) {
    return Expanded(
      child: Padding(
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
}