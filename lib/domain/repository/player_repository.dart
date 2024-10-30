

import 'package:equilibrium/domain/model/player.dart';

abstract class PlayerRepository {
  List<Player> getPlayers();
}