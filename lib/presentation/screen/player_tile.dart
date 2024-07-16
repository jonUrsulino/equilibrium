import 'package:equilibrium/domain/player.dart';
import 'package:flutter/material.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

class PlayerTile extends StatelessWidget {
  final Player player;
  final bool arrived;
  final Function onChangeArriving;

  const PlayerTile({
    required this.player,
    required this.arrived,
    required this.onChangeArriving,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String playerName = player.name;
    final double playerStars = player.stars;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            playerName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacer(
            flex: 5,
          ),
          RatingStars(
            rating: playerStars,
            iconSize: 25,
            editable: false,
          ),
          Checkbox(
            value: arrived,
            onChanged: (value) => onChangeArriving(value),
          )
        ],
      ),
    );
  }
}
