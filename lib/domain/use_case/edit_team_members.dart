
import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/domain/repository/team_repository.dart';

class EditTeamMembers {
  EditTeamMembers(this.teamRepository);

  final TeamRepository teamRepository;

  void execute(Team team, Player player) {

  }
}