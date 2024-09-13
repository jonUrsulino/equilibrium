
import 'package:equilibrium/domain/model/game.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/game/presentation/game_card.dart';

class ManagerGame {
  ManagerGame({required this.teamA, required this.teamB});

  Team teamA, teamB;

  late Game game = Game.initial(teamA, teamB);

  void createNewGame(Team team, SideTeam sideTeam) {
    switch (sideTeam) {
      case SideTeam.teamA:
        teamA = team;
        game = game.copyWith(
            teamA: team,
            stateGame: StateGame.initial
        );
      case SideTeam.teamB:
      default:
        teamB = team;
        game = game.copyWith(
            teamB: team,
            stateGame: StateGame.initial
        );
    }
  }

  void startGame() {
    game.copyWith(
      stateGame: StateGame.playing
    );
  }

  void finishGame() {
    game.copyWith(
        stateGame: StateGame.finished
    );
  }

}
