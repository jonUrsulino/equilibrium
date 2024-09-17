
import 'package:equilibrium/domain/model/game.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/presentation/screen/team_game_card.dart';
import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    required this.game,
    required this.function,
    required this.presencePlayerRepository,
    super.key,
  });

  final Game game;
  final Function function;
  final PresencePlayerRepository presencePlayerRepository;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          color: Colors.white10,
          child: Row(
            children: [
              TeamGameCard(
                  team: game.teamA,
                  sideTeam: SideTeam.teamA,
                  presencePlayerRepository: presencePlayerRepository,
                  function: function,
              ),
              TeamGameCard(
                  team: game.teamB,
                  sideTeam: SideTeam.teamB,
                  presencePlayerRepository: presencePlayerRepository,
                  function: function,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum SideTeam {
  teamA,
  teamB
}