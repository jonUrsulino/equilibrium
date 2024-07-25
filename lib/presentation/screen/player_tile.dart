import 'package:equilibrium/domain/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class PlayerTile extends StatefulWidget {
  final Player player;
  final bool arrived;
  final Function onChangeArriving;
  final bool showStars;

  const PlayerTile({
    required this.player,
    required this.arrived,
    required this.onChangeArriving,
    required this.showStars,
    super.key,
  });

  @override
  State<PlayerTile> createState() => _PlayerTileState();
}

class _PlayerTileState extends State<PlayerTile> {
  @override
  Widget build(BuildContext context) {
    final String playerName = widget.player.name;
    final double playerStars = widget.player.stars;
    final bool isGoalkeeper = widget.player.isGoalkeeper;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            playerName,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Visibility(
            visible: isGoalkeeper,
            child: const Icon(Icons.sports_handball),
          ),
          const Spacer(
            flex: 5,
          ),
          Visibility(
            visible: widget.showStars,
            child: RatingStars(
              value: playerStars,
              starSize: 18,
            ),
          ),
          Checkbox(
            value: widget.arrived,
            onChanged: (value) => widget.onChangeArriving(value),
          )
        ],
      ),
    );
  }
}
