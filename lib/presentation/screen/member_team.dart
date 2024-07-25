import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class MemberTeam extends StatefulWidget {
  final String position;
  final Player player;
  final bool arrived;

  const MemberTeam({
    required this.position,
    required this.player,
    required this.arrived,
    super.key,
  });

  @override
  State<MemberTeam> createState() => _MemberTeamState();
}

class _MemberTeamState extends State<MemberTeam> {
  final settings = GetIt.I.get<Settings>();

  @override
  Widget build(BuildContext context) {
    final String playerName = widget.player.name;
    final double playerStars = widget.player.stars;
    final bool isGoalkeeper = widget.player.isGoalkeeper;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "${widget.position}. ",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.black87),
          ),
          Text(
            playerName,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.black87),
          ),
          Visibility(
            visible: isGoalkeeper,
            child: const Icon(Icons.sports_handball),
          ),
          const Spacer(),
          Visibility(
            visible: settings.starsVisible.watch(context),
            child: RatingStars(
              value: playerStars,
              starSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
