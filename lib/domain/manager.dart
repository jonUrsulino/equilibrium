
import 'package:equilibrium/domain/game.dart';
import 'package:equilibrium/domain/team.dart';

class ManagerGame {
  ManagerGame({required this.teamA, required this.teamB});

  Team teamA, teamB;

  late var game = Game.initial(teamA, teamB);

  void createNewGame(Team teamA, Team teamB) {
    game = Game.initial(teamA, teamB);
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
