import 'package:equilibrium/data/repository/player_repository.dart';
import 'package:equilibrium/domain/manager.dart';
import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/presence_player.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/domain/repository/player_repository.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:equilibrium/domain/use_case/get_initial_presence_players_sort_by_starts.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';

abstract class DiDomain {
  static void initializeDomainDependencies() {
    GetIt.I.registerSingleton<PlayerRepository>(PlayerRepositoryImpl());
    GetIt.I.registerSingleton(GetInitialPresencePlayersSortByStarts(repository: GetIt.I.get()));
    GetIt.I.registerLazySingleton<PresencePlayers>(() {
      GetInitialPresencePlayersSortByStarts useCase = GetIt.I.get();
        List<PresencePlayer> list = useCase.execute();
        Map<String, PresencePlayer> map = { for (var h in list) h.player.name : h };
        return PresencePlayers(map);
    });
    GetIt.I.registerSingleton<Settings>(Settings());
    GetIt.I.registerSingleton<Coach>(Coach());
  }
}
