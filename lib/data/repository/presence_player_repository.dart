
import 'package:equilibrium/data/data_source/local/presence_player_data_source.dart';
import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/player_repository.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:signals/signals.dart';

class PresencePlayerRepositoryImpl implements PresencePlayerRepository {
  PresencePlayerRepositoryImpl({
    required this.repository,
    required this.localDataSource,
  }) {
    localDataSource.load(getPresencePlayersForPlayerRepositorySortedByName());
  }

  final PlayerRepository repository;
  final PresencePlayerDataSource localDataSource;

  late final MapSignal<String, PresencePlayer> _arriving = MapSignal(getPresencePlayersMappedWithNames());


  // MapSignal<String, PresencePlayer> getPresencePlayers() {
  //   return _arriving;
  // }

  @override
  Stream<List<PresencePlayer>> getPresencePlayersStream() {
    return localDataSource.getStreamAll();
  }

  @override
  Stream<PresencePlayer> getPresencePlayerStream() async* {
    List<PresencePlayer> list = localDataSource.getList();
    for (PresencePlayer item in list) {
      yield item;
    }
  }

  @override
  void playerArrived(PresencePlayer presencePlayer) {
    print('player arrived ${presencePlayer.player.name}');

    var changed = presencePlayer.copyWith(statePresence: StatePresence.arrived);
    localDataSource.save(changed);
  }

  @override
  void playerConfirmed(PresencePlayer presencePlayer, bool value) {
    print('player promised ${presencePlayer.player.name}');

    var changed = presencePlayer.copyWith(statePresence: StatePresence.confirmed);
    localDataSource.save(changed);
  }

  @override
  void playerMissed(PresencePlayer presencePlayer, bool value) {
    print('player missed ${presencePlayer.player.name}');

    var changed = presencePlayer.copyWith(statePresence: StatePresence.confirmed);
    localDataSource.save(changed);
  }

  @override
  void playerCanceled(PresencePlayer presencePlayer) {
    print('player canceled ${presencePlayer.player.name}');

    var changed = presencePlayer.copyWith(statePresence: StatePresence.initial);
    localDataSource.save(changed);
  }

  @override
  void addNewPlayer(PresencePlayer value) {
    if (!localDataSource.containsByName(value.player.name)) {
      localDataSource.save(value);
    } else {
      print('Player name duplicated');
    }
  }

  @override
  PresencePlayer? getPlayerByName(String playerName) {
    return _arriving[playerName];
  }

  // @override
  // Computed<PresencePlayer?> getComputedPlayerByName(String playerName) {
  //   return computed(() => getPresencePlayers()[playerName]);
  // }

  @override
  Stream<PresencePlayer?> getStreamPlayerById(String id) {
    return localDataSource.listen(id);
  }

  // @override
  // Computed<List<PresencePlayer>> getComputedPresencePlayersOrderedByName() {
  //   return computed<List<PresencePlayer>>(() => getPresencePlayers().values
  //       .where((element) {
  //         return element.statePresence == StatePresence.initial;
  //       })
  //       .toList()..sort((a, b) => a.player.name.compareTo(b.player.name),
  //   ));
  // }

  // @override
  // Computed<List<PresencePlayer>> getComputedArrivedPresencePlayers() {
  //   return computed<List<PresencePlayer>>(() {
  //     return getPresencePlayers().values.where((element) {
  //       return element.statePresence == StatePresence.arrived;
  //     }).toList();
  //   });
  // }

  @override
  Stream<List<PresencePlayer>> getStreamPresencePlayersWhere(StatePresence statePresence) async* {
    await for (var list in getPresencePlayersStream()) {
      yield list
          .where((element) => element.statePresence == statePresence)
          .toList();
    }
  }

  @override
  Future<List<PresencePlayer>> getFuturePresencePlayersWhere(StatePresence statePresence) async {
    Stream<PresencePlayer> presencePlayersStream = getPresencePlayerStream();

    List<PresencePlayer> players = List.empty(growable: true);
    await for (PresencePlayer presencePlayer in presencePlayersStream) {
      // print("await for presencePlayer ${presencePlayer.player.name}");
      players.add(presencePlayer);
    }

    for (var itemList in players) {
      print("HERE! for returning ${itemList.player.name}");
    }

    return players;

    // List<PresencePlayer> lists = await streams;
    //
    // for (var itemList in lists) {
    //   print("await for itemList ${itemList}");
    // }
    //
    // List<PresencePlayer> returning = lists
    //     .where((element) => element.statePresence == statePresence)
    //     .toList();
    //
    // for (var item in returning) {
    //   print("await for returning item ${item.player.name}");
    // }
    // return returning;
  }

  @override
  Stream<int> getStreamLengthPresencePlayersWhere(StatePresence statePresence) async* {
    await for (var list in getPresencePlayersStream()) {
      yield list
          .where((element) => element.statePresence == statePresence)
          .length;
    }
  }

  // @override
  // Computed<List<PresencePlayer>> getComputedArrivedPresencePlayersWithoutGoalkeepers() {
  //   return computed<List<PresencePlayer>>(() {
  //     return getComputedArrivedPresencePlayers().get().where((element) {
  //       return !element.player.isGoalkeeper;
  //     }).toList();
  //   });
  // }

  @override
  Future<List<PresencePlayer>> getStreamPresencePlayersFiltered({
    required StatePresence wherePresence,
    required bool withGoalkeeper,
  }) async {
    List<PresencePlayer> presencePlayers = await getPresencePlayersStream().first;

      return presencePlayers
          .where((element) => element.statePresence == wherePresence)
          .where((element) => element.player.isGoalkeeper == withGoalkeeper)
          .toList();

  }

  @override
  Future<List<PresencePlayer>> getFuturePresencePlayersFiltered({
    required StatePresence wherePresence,
    required bool withGoalkeeper,
  }) async {
    var streamPresencePlayersFiltered = getStreamPresencePlayersFiltered(
        wherePresence: wherePresence,
        withGoalkeeper: withGoalkeeper
    );

    return streamPresencePlayersFiltered;

    // await for (List<PresencePlayer> presencePlayers in getPresencePlayersStream()) {
    //   return presencePlayers
    //       .where((element) => element.statePresence == wherePresence)
    //       .where((element) => element.player.isGoalkeeper == withGoalkeeper)
    //       .toList();
    // }
  }

  // @override
  // Computed<List<PresencePlayer>> getComputedConfirmedPresencePlayers() {
  //   return computed<List<PresencePlayer>>(() {
  //     return getPresencePlayers()
  //         .values
  //         .where((element) {
  //       return element.statePresence == StatePresence.confirmed;
  //     }).toList();
  //   });
  // }

  @override
  List<PresencePlayer> getPresencePlayersByNames(List<String> names) {
    final List<PresencePlayer> presencePlayers = List.empty(growable: true);
    for (String playerName in names) {
      PresencePlayer? presencePlayer = getPlayerByName(playerName);
      presencePlayer ??= PresencePlayer.ghost(Player.ghost());
      presencePlayers.add(presencePlayer);
    }
    return presencePlayers;
  }

  @override
  List<PresencePlayer> getPresencePlayersForPlayerRepositorySortedByName() {
    return repository
        .getPlayers()
        .map((player) => PresencePlayer.initial(player))
        .toList()..sort((a, b) => a.player.name.compareTo(b.player.name));
  }

  @override
  Map<String, PresencePlayer> getPresencePlayersMappedWithNames() {
    List<PresencePlayer> list = getPresencePlayersForPlayerRepositorySortedByName();
    return { for (var h in list) h.player.name : h };
  }
}