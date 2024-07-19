import 'package:equilibrium/domain/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class MemberTeam extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final String playerName = player.name;
    final double playerStars = player.stars;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '$position. $playerName',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacer(
            flex: 5,
          ),
          RatingStars(
            value: playerStars,
          ),
        ],
      ),
    );
  }
}
