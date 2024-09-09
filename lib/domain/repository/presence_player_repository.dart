
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:signals/signals.dart';

abstract class PresencePlayerRepository {
  MapSignal<String, PresencePlayer> getPresencePlayers();

  // TODO: Could be UseCases.
  void addNewPlayer(PresencePlayer value);
  PresencePlayer? getPlayerByName(String playerName);
  void playerArrived(PresencePlayer presencePlayer, bool value);
  void playerConfirmed(PresencePlayer presencePlayer, bool value);
  void playerMissed(PresencePlayer presencePlayer, bool value);
  void playerCanceled(PresencePlayer presencePlayer);

  void dispose();
}