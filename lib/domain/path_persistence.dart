

// TODO refactor it all.
class PathPersistence {
  PathPersistence() {
    // pathProviderPlayer();
    // pathProviderPresencePlayer();
  }

  static get pathPlayers => '/data/user/0/com.example.equilibrium/app_flutter/player.json';

  static get pathPresencePlayer => '/data/user/0/com.example.equilibrium/app_flutter/presence_player.json';

  // static Future<String> pathProviderPlayer() async {
  //     Directory applicationDocumentsDirectory = await getApplicationDocumentsDirectory();
  //     var path = '${applicationDocumentsDirectory.path}/persistence/player.json';
  //     pathPlayers = path;
  //     print('Path persistence: $pathPlayers');
  //     return path;
  // }
  //
  // static Future<String> pathProviderPresencePlayer() async {
  //   Directory applicationDocumentsDirectory = await getApplicationDocumentsDirectory();
  //   var path = '${applicationDocumentsDirectory.path}/persistence/presence_player.json';
  //   pathPresencePlayer = path;
  //   print('Path persistence: $pathPresencePlayer');
  //   return path;
  // }
}