part of 'game_bloc.dart';

@immutable
sealed class GameEvent {}

final class LoadGameEvent extends GameEvent {}

final class ChangeLoseTeamEvent extends GameEvent {
  ChangeLoseTeamEvent({
    required this.loserTeam,
    required this.sideTeam
  });

  final SideTeam sideTeam;
  final Team loserTeam;
}
