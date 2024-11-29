part of 'balance_bloc.dart';

@immutable
sealed class BalanceEvent {}

final class BalanceLoadEvent extends BalanceEvent {}
final class BalanceTeamsEvent extends BalanceEvent {
  BalanceTeamsEvent(this.single);

  List<PresencePlayer> single;
}
