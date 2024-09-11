
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';

class GetArrivedPresencePlayersOfTeam {
  GetArrivedPresencePlayersOfTeam(this.presencePlayerRepository);

  final PresencePlayerRepository presencePlayerRepository;
  
  List<PresencePlayer> useCase(Team team) {
    return team.actualPresencePlayers(presencePlayerRepository);
  }
}