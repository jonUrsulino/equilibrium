import 'package:equilibrium/data/repository/player_repository.dart';
import 'package:equilibrium/data/repository/presence_player_repository.dart';
import 'package:equilibrium/data/repository/team_repository.dart';
import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/repository/player_repository.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/repository/team_repository.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:equilibrium/domain/use_case/get_initial_players_sort_by_name.dart';
import 'package:equilibrium/domain/use_case/get_initial_presence_players_sort_by_starts.dart';
import 'package:equilibrium/domain/use_case/get_presence_players_mapped_with_names.dart';
import 'package:get_it/get_it.dart';

abstract class DiDomain {
  static void initializeDomainDependencies() {
    // ! Check if a injected class is referenced only after it was registered.
    GetIt.I.registerSingleton<PlayerRepository>(PlayerRepositoryImpl());
    GetIt.I.registerSingleton(GetInitialPresencePlayersSortByNames(repository: GetIt.I.get<PlayerRepository>()));
    GetIt.I.registerSingleton(GetPresencePlayersMappedWithNames(useCase: GetIt.I.get<GetInitialPresencePlayersSortByNames>()));
    GetIt.I.registerSingleton<PresencePlayerRepository>(PresencePlayerRepositoryImpl(useCase: GetIt.I.get<GetPresencePlayersMappedWithNames>()));
    GetIt.I.registerSingleton<TeamRepository>(TeamRepositoryImpl());
    GetIt.I.registerSingleton(GetInitialPresencePlayersSortByStarts(repository: GetIt.I.get<PlayerRepository>()));
    GetIt.I.registerSingleton(Settings());
    GetIt.I.registerSingleton(Coach());
  }
}
