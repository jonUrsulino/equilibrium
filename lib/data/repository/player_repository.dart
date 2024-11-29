

import 'package:equilibrium/data/data_source/local/player_data_source.dart';
import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/repository/player_repository.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  PlayerRepositoryImpl(this.dataSource);

  final PlayerDataSource dataSource;

  @override
  List<Player> getPlayers() {
    print("getPlayers");
    return dataSource.getPlayersStored();
  }
}