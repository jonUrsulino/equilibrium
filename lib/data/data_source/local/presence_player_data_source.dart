
import 'package:equilibrium/domain/model/presence_player.dart';

abstract class PresencePlayerDataSource {

  void load(List<PresencePlayer> presencePlayersSortedByName);
  void save(PresencePlayer newPresencePlayer);
  bool contains(String id);
  PresencePlayer getForced(String id);
  List<PresencePlayer> getList();
  Stream<PresencePlayer?> listen(String id);
  Stream<List<PresencePlayer>> getStreamAll();

  bool containsByName(String name);
}