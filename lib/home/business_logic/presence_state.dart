part of 'presence_bloc.dart';

@immutable
sealed class PresenceState {}

final class PresenceInitial extends PresenceState {}
final class AddPlayerPresenceState extends PresenceState {}
