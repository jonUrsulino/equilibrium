import 'package:equilibrium/domain/coach.dart';
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
      return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: coach.presence.getArrivedWith(true).length,
        itemBuilder: (context, index) {
          var player = coach.presence.getArrivedWith(true)[index].player;
          return MemberTeam(
            position: (index + 1).toString(),
            player: player,
            arrived: true,
          );
        },
      );
    } else {
      return _buildTeams(context);
    }
  }

  ListView _buildTeams(BuildContext context) {
    final teams = coach.teams.watch(context);

    return ListView.builder(
        itemCount: teams.length,
        itemBuilder: (context, index) {
          var team = teams[index];
          return Column(
            children: [
              ColoredBox(
                color: team.shirt.color,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${team.shirt.name}: Poder do time: ${team.calculatePower()}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepOrangeAccent),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    border: Border.all(
                  color: team.shirt.color,
                )),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: team.players.length,
                  itemBuilder: (context, index) {
                    var player = team.players[index];
                    return MemberTeam(
                      position: (index + 1).toString(),
                      player: player,
                      arrived: true,
                    );
                  },
                ),
              ),
            ],
          );
        });
  }
}
