
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:signals/signals.dart';

abstract class PresencePlayerRepository {
  Stream<List<PresencePlayer>> getPresencePlayersStream();
  Stream<PresencePlayer> getPresencePlayerStream();
  List<PresencePlayer> getPresencePlayersForPlayerRepositorySortedByName();
  Map<String, PresencePlayer> getPresencePlayersMappedWithNames();

  PresencePlayer? getPlayerByName(String playerName);
  List<PresencePlayer> getPresencePlayersByNames(List<String> names);

  Stream<PresencePlayer?> getStreamPlayerById(String id);

  Future<List<PresencePlayer>> getStreamPresencePlayersFiltered({
    required StatePresence wherePresence,
    required bool withGoalkeeper,
  });
  Future<List<PresencePlayer>> getFuturePresencePlayersFiltered({
    required StatePresence wherePresence,
    required bool withGoalkeeper,
  });

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