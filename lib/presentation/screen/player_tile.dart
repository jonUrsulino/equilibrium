import 'package:equilibrium/domain/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

class PlayerTile extends StatelessWidget {
  final Player player;

  const PlayerTile({required this.player, super.key});

  @override
  Widget build(BuildContext context) {
    final String playerName = player.name;
    final double playerStars = player.stars;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(playerName),
          const Spacer(),
          RatingStars(
            rating: playerStars,
            iconSize: 25,
            editable: true,
          ),
        ],
      ),
    );
  }
}
