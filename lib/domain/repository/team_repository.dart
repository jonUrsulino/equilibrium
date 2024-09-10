
import 'package:equilibrium/domain/model/team.dart';
import 'package:signals/signals.dart';

abstract class TeamRepository {
  ListSignal<Team> getTeams();
  void load(List<Team> teams);
  void addNewTeam(Team team);
  void changeOrder(Team team);

  Signal<Team> nextIncompleteTeam();
}