
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:signals/signals.dart';

abstract class PresencePlayerRepository {
  MapSignal<String, PresencePlayer> getPresencePlayers();

  void addNewPlayer(PresencePlayer value);
  void playerArrived(PresencePlayer presencePlayer, bool value);
  void playerConfirmed(PresencePlayer presencePlayer, bool value);
  void playerMissed(PresencePlayer presencePlayer, bool value);
  void playerCanceled(PresencePlayer presencePlayer);
}