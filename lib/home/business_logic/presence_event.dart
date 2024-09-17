part of 'presence_bloc.dart';

@immutable
sealed class PresenceEvent {}

final class AddPlayerPresenceEvent extends PresenceEvent {}
