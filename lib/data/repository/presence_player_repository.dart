
import 'package:equilibrium/data/data_source/local/presence_player_data_source.dart';
import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/player_repository.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:get_it/get_it.dart';
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
    if (localDataSource.containsByName(playerName)) {
      return localDataSource.getPresencePlayerByName(playerName);
    }
    return null;
  }

  @override
  Stream<PresencePlayer?> getStreamPlayerById(String id) {
    print("getStreamPlayerById $id");
    return localDataSource.listen(id);
  }

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
    await for (PresencePlayer presencePlayer in presencePlayersStream.where((player) => player.statePresence == statePresence)) {
      players.add(presencePlayer);
    }

    for (var itemList in players) {
      print("HERE! for returning ${itemList.player.name}");
    }

    return players;
  }

  @override
  Stream<int> getStreamLengthPresencePlayersWhere(StatePresence statePresence) async* {
    await for (var list in getPresencePlayersStream()) {
      yield list
          .where((element) => element.statePresence == statePresence)
          .length;
    }
  }

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
  }

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