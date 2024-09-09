import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:signals/signals_flutter.dart';

class MemberTeamWidget extends StatelessWidget {
  final PresencePlayer presencePlayer;
  final String position;
  final Settings settings;

  const MemberTeamWidget({
    required this.settings,
    required this.presencePlayer,
    required this.position,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Player player = presencePlayer.player;
    final bool hasNotArrived = presencePlayer.statePresence == StatePresence.confirmed;
    final String playerName = player.name;
    final double playerStars = player.stars;
    final bool isGoalkeeper = player.isGoalkeeper;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "${position}. ",
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
          Visibility(
            visible: hasNotArrived,
            child: const Icon(Icons.call_missed),
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
