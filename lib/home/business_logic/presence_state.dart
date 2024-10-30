part of 'presence_bloc.dart';

@immutable
sealed class PresenceState {}

final class PresenceInitial extends PresenceState {}
final class PresenceLengthState extends PresenceState {
  PresenceLengthState(this.lengthArrivedPlayers);

  final int lengthArrivedPlayers;
}
final class AddPlayerPresenceState extends PresenceState {}
