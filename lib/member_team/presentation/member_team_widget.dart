import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class MemberTeamWidget extends StatefulWidget {
  final PresencePlayer presencePlayer;
  final String position;

  final PresencePlayerRepository repository = GetIt.I.get();
  final Settings settings = GetIt.I.get();

  late final Computed<PresencePlayer?> presencePlayerSignal = repository
      .getComputedPlayerByName(presencePlayer.player.name);

  MemberTeamWidget(Key? key, {
    required this.presencePlayer,
    required this.position,
  }) : super(key: key);

  @override
  State<MemberTeamWidget> createState() => _MemberTeamWidgetState();
}

class _MemberTeamWidgetState extends State<MemberTeamWidget> {

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      PresencePlayer? presencePlayer = widget.presencePlayerSignal.watch(context);
      presencePlayer ??= PresencePlayer.ghost(Player.ghost());

      final Player player = presencePlayer.player;
      print('member widget player: ${player.name}');
      final bool hasNotArrived = presencePlayer.statePresence == StatePresence.confirmed;
      final String playerName = player.name;
      final double playerStars = player.stars;
      final bool isGoalkeeper = player.isGoalkeeper;

      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("${widget.position}. ",
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
              visible: widget.settings.starsVisible.watch(context),
              child: RatingStars(
                value: playerStars,
                starSize: 15,
              ),
            ),
          ],
        ),
      );
    });
  }
}
