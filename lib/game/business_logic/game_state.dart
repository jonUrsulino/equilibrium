part of 'game_bloc.dart';

@immutable
sealed class GameState {}

final class GameInitial extends GameState {}

final class GameLoad extends GameState {
  GameLoad({
    required this.game,
    required this.nextTeams,
  });
  final Game game;
  final List<Team> nextTeams;
}
