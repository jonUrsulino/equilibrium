import 'package:equilibrium/data/repository/player_repository.dart';
import 'package:equilibrium/data/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/repository/player_repository.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:equilibrium/domain/use_case/get_computed_arrived_players.dart';
import 'package:equilibrium/domain/use_case/get_computed_arrived_players_except_goalkeepers.dart';
import 'package:equilibrium/domain/use_case/get_computed_presence_player_by_team.dart';
import 'package:equilibrium/domain/use_case/get_computed_presence_players_sorted_by_name.dart';
import 'package:equilibrium/domain/use_case/get_computed_confirmed_players_sort_by_name.dart';
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
    GetIt.I.registerSingleton(GetInitialPresencePlayersSortByStarts(repository: GetIt.I.get<PlayerRepository>()));
    GetIt.I.registerSingleton(GetComputedArrivedPresencePlayers(repository: GetIt.I.get<PresencePlayerRepository>()));
    GetIt.I.registerSingleton(GetComputedArrivedPresencePlayersExceptGoalkeepers(useCase: GetIt.I.get<GetComputedArrivedPresencePlayers>()));
    GetIt.I.registerSingleton(GetComputedPresencePlayersSortedByName(repository: GetIt.I.get<PresencePlayerRepository>()));
    GetIt.I.registerSingleton(GetComputedConfirmedPlayersSortByName(repository: GetIt.I.get<PresencePlayerRepository>()));
    GetIt.I.registerSingleton(GetComputedPresencePlayerByName(repository: GetIt.I.get<PresencePlayerRepository>()));
    GetIt.I.registerSingleton(Settings());
    GetIt.I.registerSingleton(Coach());
  }
}
