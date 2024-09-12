
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:signals/signals.dart';

abstract class PresencePlayerRepository {
  MapSignal<String, PresencePlayer> getPresencePlayers();

  PresencePlayer? getPlayerByName(String playerName);
  List<PresencePlayer> getPresencePlayersByNames(List<String> names);
  Computed<PresencePlayer?> getComputedPlayerByName(String playerName);
  Computed<List<PresencePlayer>> getComputedPresencePlayersOrderedByName();
  Computed<List<PresencePlayer>> getComputedArrivedPresencePlayers();
  Computed<List<PresencePlayer>> getComputedArrivedAndGhostPresencePlayers();
  Computed<List<PresencePlayer>> getComputedArrivedPresencePlayersWithoutGoalkeepers();
  Computed<List<PresencePlayer>> getComputedConfirmedPresencePlayers();


  // TODO: Could be UseCases.
  void addNewPlayer(PresencePlayer value);
  void playerArrived(PresencePlayer presencePlayer);
  void playerConfirmed(PresencePlayer presencePlayer, bool value);
  void playerMissed(PresencePlayer presencePlayer, bool value);
  void playerCanceled(PresencePlayer presencePlayer);
}