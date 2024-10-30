
import 'package:equilibrium/domain/model/player.dart';

abstract class PlayerDataSource {
  List<Player> getPlayersStored();
}