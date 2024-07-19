import 'package:equilibrium/domain/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class PlayerTile extends StatefulWidget {
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
  State<PlayerTile> createState() => _PlayerTileState();
}

class _PlayerTileState extends State<PlayerTile> {
  @override
  Widget build(BuildContext context) {
    final String playerName = widget.player.name;
    final double playerStars = widget.player.stars;

    return Padding(
      padding: const EdgeInsets.all(4.0),
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
            value: playerStars,
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
