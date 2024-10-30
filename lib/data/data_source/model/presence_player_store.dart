
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:simple_persistence/simple_persistence.dart';

class PresencePlayerStore extends Storable {
  PresencePlayerStore(this.presencePlayer);

  PresencePlayerStore.fromMap(Map<String, dynamic> map) : presencePlayer = map['presencePlayer'];

  final PresencePlayer presencePlayer;

  @override
  Map get data => {
    'presencePlayer': presencePlayer
  };

  static final store = JsonFileStore<PresencePlayerStore>(
    path: '../persistence/presence_player_store.json',
  );

  PresencePlayerStore copyWith({PresencePlayer? presencePlayer}) =>
      PresencePlayerStore(presencePlayer ?? this.presencePlayer)
        ..id = id;
}

extension PresencePlayerExtensions on PresencePlayer {
  PresencePlayerStore asStore() => PresencePlayerStore(this);
}