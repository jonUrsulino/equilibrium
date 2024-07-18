import 'package:equilibrium/domain/presence.dart';
import 'package:get_it/get_it.dart';

abstract class DiDomain {
  static void initializeDomainDependencies() {
    GetIt.I.registerSingleton<PresencePlayers>(PresencePlayers());
  }
}
