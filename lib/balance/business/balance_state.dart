part of 'balance_bloc.dart';

@immutable
sealed class BalanceState {}

final class BalanceInitialState extends BalanceState {}

final class NotBalancedState extends BalanceState {
  NotBalancedState(this.teamPresencePlayers);

  final List<PresencePlayer> teamPresencePlayers;
}

final class BalancedTeamsState extends BalanceState {
  BalancedTeamsState(this.mapTeamsPresencePlayers);

  final Map<Team, List<PresencePlayer>> mapTeamsPresencePlayers;
}
