
import 'package:equatable/equatable.dart';
import 'package:equilibrium/domain/model/team.dart';

class Game extends Equatable {
  const Game._({
    required this.teamA,
    required this.teamB,
    required this.stateGame
  });

  const Game.initial(
      this.teamA,
      this.teamB
      ) : stateGame = StateGame.initial;

  final Team teamA;
  final Team teamB;
  final StateGame stateGame;

  @override
  List<Object?> get props => [teamA, teamB, stateGame];

  Game copyWith({
    Team? teamA,
    Team? teamB,
    StateGame? stateGame
  }) {
    return Game._(
        teamA: teamA ?? this.teamA,
        teamB: teamB ?? this.teamB,
        stateGame: stateGame ?? this.stateGame
    );
  }
}

enum StateGame {
  initial, playing, finished
}