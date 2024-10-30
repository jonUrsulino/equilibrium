import 'package:equilibrium/data/data_source/local/player_data_source.dart';
import 'package:equilibrium/data/data_source/local/presence_player_data_source.dart';
import 'package:equilibrium/data/data_source/local/store_player_data_source.dart';
import 'package:equilibrium/data/data_source/local/store_presence_player_data_source.dart';
import 'package:equilibrium/data/repository/player_repository.dart';
import 'package:equilibrium/data/repository/presence_player_repository.dart';
import 'package:equilibrium/data/repository/team_repository.dart';
import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/controller_manager.dart';
import 'package:equilibrium/domain/path_persistence.dart';
import 'package:equilibrium/domain/repository/player_repository.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/repository/team_repository.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:equilibrium/domain/use_case/notify_arrived_player.dart';
import 'package:get_it/get_it.dart';

abstract class DiDomain {
  static void initializeDomainDependencies() {
    // ! Check if a injected class is referenced only after it was registered.
    GetIt.I.registerSingleton(PathPersistence());
    GetIt.I.registerSingleton<PlayerDataSource>(StorePlayerDataSource());
    GetIt.I.registerSingleton<PresencePlayerDataSource>(StorePresencePlayerDataSource());
    GetIt.I.registerSingleton<PlayerRepository>(PlayerRepositoryImpl(GetIt.I.get<PlayerDataSource>()));
    GetIt.I.registerSingleton<PresencePlayerRepository>(PresencePlayerRepositoryImpl(
        repository: GetIt.I.get<PlayerRepository>(),
        localDataSource: GetIt.I.get<PresencePlayerDataSource>()
    ));
    GetIt.I.registerSingleton<TeamRepository>(TeamRepositoryImpl());
    GetIt.I.registerSingleton(Settings());
    GetIt.I.registerSingleton(Coach());
    GetIt.I.registerSingleton(ControllerManager());
    GetIt.I.registerSingleton(NotifyArrivedPlayer(
        GetIt.I.get<PresencePlayerRepository>(),
        GetIt.I.get<TeamRepository>(),
        GetIt.I.get<Settings>())
    );
  }
}
