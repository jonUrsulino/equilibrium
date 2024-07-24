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
                  Container(
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
                          Icons.stars,
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
                  ),
                  Container(
                    margin: const EdgeInsets.all(3),
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
}
