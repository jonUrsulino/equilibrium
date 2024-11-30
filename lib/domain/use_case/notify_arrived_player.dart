
import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/model/shirt.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/repository/shirt_repository.dart';
import 'package:equilibrium/domain/repository/team_repository.dart';
import 'package:equilibrium/domain/settings.dart';

class NotifyArrivedPlayer {
  NotifyArrivedPlayer(this.repository, this.teamRepository, this.settings, this.shirtRepository);

  final PresencePlayerRepository repository;
  final TeamRepository teamRepository;
  final Settings settings;
  final ShirtRepository shirtRepository;

  void execute(PresencePlayer presencePlayer) {
    var presencePlayersUpdated = presencePlayer.copyWith(statePresence: StatePresence.arrived);
    repository.playerArrived(presencePlayersUpdated);

    if (teamRepository.getTeams().isNotEmpty) {
      var index = indexTeamWithThisPlayer(presencePlayer.player);
      if (exists(index)) {
        // do nothing.
      } else {
        var indexTeam = indexOfIncompleteTeam();
        if (exists(indexTeam)) {
          putArrivedPlayerIntoIncompleteTeam(indexTeam, presencePlayer.player);
        } else {
          createNewTeam(presencePlayersUpdated.player);
        }
      }
    }
  }

  void putArrivedPlayerIntoIncompleteTeam(int indexTeam, Player player) {
    Team team = teamRepository.getTeams().value[indexTeam];

    final List<Player> notArrivedPlayers = team.notArrivedPlayers(repository).map((e) => e.player).toList();
    final List<Player> arrivedPlayers = team.arrivedPlayers(repository).map((e) => e.player).toList();

    notArrivedPlayers.first = player;
    team = team.copyWith(
        players: arrivedPlayers + notArrivedPlayers
    );
    teamRepository.getTeams().value[indexTeam] = team;
  }

  void createNewTeam(Player player) {
    final Shirt shirt = shirtRepository.getNextShirt();
    var team = Team.incomplete(shirt: shirt, );
    team.players.add(player);

    var ghostsLength = settings.maxPlayersByTeam.value - 1;
    for (int i = 0; i < ghostsLength; i++) {
      team.players.add(Player.ghost());
    }
    teamRepository.addNewTeam(team);
  }

  int indexTeamWithThisPlayer(Player player) {
    var indexWhere = teamRepository
        .getTeams().value
        .indexWhere((element) => element.players.contains(player));
    return indexWhere;
  }

  int indexOfIncompleteTeam() {
    var indexWhere = teamRepository
        .getTeams().value
        .indexWhere((team) => team.notArrivedPlayers(repository).isNotEmpty);
    return indexWhere;
  }

  bool exists(int index) {
    return index >= 0;
  }
}