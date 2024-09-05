
import 'package:equilibrium/domain/game.dart';
import 'package:equilibrium/domain/team.dart';
import 'package:equilibrium/presentation/screen/game_screen.dart';
import 'package:signals/signals.dart';

class ManagerGame {
  ManagerGame({required this.teamA, required this.teamB});

  Team teamA, teamB;

  late final game = Signal(Game.initial(teamA, teamB));

  void createNewGame(Team team, SideTeam sideTeam) {
    switch (sideTeam) {
      case SideTeam.teamA:
        teamA = team;
        game.value.copyWith(
            teamA: team,
            stateGame: StateGame.initial
        );
      case SideTeam.teamB:
      default:
        teamB = team;
        game.value.copyWith(
            teamB: team,
            stateGame: StateGame.initial
        );
    }
  }

  void startGame() {
    game.value.copyWith(
      stateGame: StateGame.playing
    );
  }

  void finishGame() {
    game.value.copyWith(
        stateGame: StateGame.finished
    );
  }

}
