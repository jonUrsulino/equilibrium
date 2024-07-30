import 'package:equilibrium/domain/Manager.dart';
import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:get_it/get_it.dart';

abstract class DiDomain {
  static void initializeDomainDependencies() {
    GetIt.I.registerSingleton<PresencePlayers>(PresencePlayers());
    GetIt.I.registerSingleton<Settings>(Settings());
    GetIt.I.registerSingleton<Coach>(Coach());
    GetIt.I.registerSingleton<Manager>(Manager());
  }
}
