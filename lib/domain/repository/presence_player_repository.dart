
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:signals/signals.dart';

abstract class PresencePlayerRepository {
  // @Deprecated("Need to be replaced")
  // MapSignal<String, PresencePlayer> getPresencePlayers();
  Stream<List<PresencePlayer>> getPresencePlayersStream();
  Stream<PresencePlayer> getPresencePlayerStream();
  List<PresencePlayer> getPresencePlayersForPlayerRepositorySortedByName();
  Map<String, PresencePlayer> getPresencePlayersMappedWithNames();

  PresencePlayer? getPlayerByName(String playerName);
  List<PresencePlayer> getPresencePlayersByNames(List<String> names);

  // @Deprecated("Need to be replaced by getStreamPlayerById()")
  // Computed<PresencePlayer?> getComputedPlayerByName(String playerName);
  Stream<PresencePlayer?> getStreamPlayerById(String id);

  // @Deprecated("Need to be replaced by getStreamPresencePlayersWhere")
  // Computed<List<PresencePlayer>> getComputedPresencePlayersOrderedByName();
  // @Deprecated("Need to be replaced by getStreamPresencePlayersWhere")
  // Computed<List<PresencePlayer>> getComputedArrivedPresencePlayers();
  // @Deprecated("Need to be replaced by getStreamPresencePlayersWhere")
  // Computed<List<PresencePlayer>> getComputedArrivedPresencePlayersWithoutGoalkeepers();
  Future<List<PresencePlayer>> getStreamPresencePlayersFiltered({
    required StatePresence wherePresence,
    required bool withGoalkeeper,
  });
  Future<List<PresencePlayer>> getFuturePresencePlayersFiltered({
    required StatePresence wherePresence,
    required bool withGoalkeeper,
  });
  // @Deprecated("Need to be replaced by getStreamPresencePlayersWhere")
  // Computed<List<PresencePlayer>> getComputedConfirmedPresencePlayers();
  Stream<List<PresencePlayer>> getStreamPresencePlayersWhere(StatePresence statePresence);
  Future<List<PresencePlayer>> getFuturePresencePlayersWhere(StatePresence statePresence);
  Stream<int> getStreamLengthPresencePlayersWhere(StatePresence statePresence);


  // TODO: Could be UseCases.
  void addNewPlayer(PresencePlayer value);
  void playerArrived(PresencePlayer presencePlayer);
  void playerConfirmed(PresencePlayer presencePlayer, bool value);
  void playerMissed(PresencePlayer presencePlayer, bool value);
  void playerCanceled(PresencePlayer presencePlayer);
}