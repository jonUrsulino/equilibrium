

import 'package:equilibrium/domain/model/player.dart';
import 'package:signals/signals.dart';

abstract class PlayerRepository {
  ListSignal<Player> getPlayers();
}