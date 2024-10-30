
import 'package:equilibrium/data/data_source/local/presence_player_data_source.dart';
import 'package:equilibrium/domain/model/presence_player.dart';

class StorePresencePlayerDataSource implements PresencePlayerDataSource {
  StorePresencePlayerDataSource();

  @override
  void load(List<PresencePlayer> presencePlayersSortedByName) {
    for (var presencePlayer in presencePlayersSortedByName) {
      PresencePlayer.store.save(presencePlayer);
    }
  }

  @override
  void save(PresencePlayer newPresencePlayer) {
    PresencePlayer.store.save(newPresencePlayer);
  }

  @override
  bool contains(String id) {
    return PresencePlayer.store.get(id) != null;
  }

  @override
  PresencePlayer getForced(String id) {
    return PresencePlayer.store.get(id)!;
  }

  @override
  List<PresencePlayer> getList() {
    return PresencePlayer.store.list();
  }

  @override
  Stream<PresencePlayer?> listen(String id) {
    return PresencePlayer.store.listen(id);
  }

  @override
  Stream<List<PresencePlayer>> getStreamAll() {
    return PresencePlayer.store.listenAll();
  }

  @override
  bool containsByName(String name) {
    //TODO: Implement it.
    return true;
  }
}