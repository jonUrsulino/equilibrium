
import 'package:equilibrium/domain/model/player.dart';
import 'package:simple_persistence/simple_persistence.dart';

class PlayerStore extends Storable {
  PlayerStore(this.player);

  PlayerStore.fromMap(Map<String, dynamic> map) : player = map['player'];

  final Player player;

  @override
  Map get data => {
    'player': player
  };

  static final store = JsonFileStore<PlayerStore>(
    path: '../persistence/player_store.json',
  );

  PlayerStore copyWith({Player? player}) =>
      PlayerStore(player ?? this.player)
        ..id = id;
}

extension PlayerExtensions on Player {
  PlayerStore asStore() => PlayerStore(this);
}