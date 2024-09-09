import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class MemberTeam extends StatefulWidget {
  final String position;
  final PresencePlayer presencePlayer;
  final bool arrived;

  const MemberTeam({
    required this.position,
    required this.presencePlayer,
    required this.arrived,
    super.key,
  });

  @override
  State<MemberTeam> createState() => _MemberTeamState();
}

class _MemberTeamState extends State<MemberTeam> {
  final Settings settings = GetIt.I.get();
  final PresencePlayerRepository presencePlayerRepository = GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    PresencePlayer? presencePlayer = presencePlayerRepository.getComputedPlayerByName(widget.presencePlayer.player.name).watch(context);
    presencePlayer ??= widget.presencePlayer;

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

  @override
  void dispose() {
    presencePlayerRepository.dispose();
    super.dispose();
  }
}
