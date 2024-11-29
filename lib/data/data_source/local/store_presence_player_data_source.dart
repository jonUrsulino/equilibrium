
import 'package:equilibrium/data/data_source/local/presence_player_data_source.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:flutter/cupertino.dart';

class StorePresencePlayerDataSource implements PresencePlayerDataSource {
  StorePresencePlayerDataSource();

  @override
  void load(List<PresencePlayer> presencePlayersSortedByName) {
    print("SAVE all players again");
    for (var presencePlayer in presencePlayersSortedByName) {
      PresencePlayer.store.save(presencePlayer);
    }
  }

  @override
  void save(PresencePlayer newPresencePlayer) {
    PresencePlayer.store.save(newPresencePlayer);
    print("SAVED ${newPresencePlayer.id}");
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
    var list = PresencePlayer.store.list();
    print("GET LIST all players");
    return list;
  }

  @override
  PresencePlayer getPresencePlayerByName(String name) {
    return getList().firstWhere((element) => element.player.name == name);
  }

  @override
  Stream<PresencePlayer?> listen(String id) {
    print("listen id $id");
    return PresencePlayer.store.listen(id);
  }

  @override
  Stream<List<PresencePlayer>> getStreamAll() {
    print("GET LIST all players by stream");
    return PresencePlayer.store.listenAll();
  }

  @override
  bool containsByName(String name) {
    return getList().where((element) => element.player.name == name).isNotEmpty;
  }
}