
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/domain/repository/team_repository.dart';
import 'package:signals/signals.dart';

class TeamRepositoryImpl extends TeamRepository {

  final ListSignal<Team> _teams = ListSignal([]);

  @override
  ListSignal<Team> getTeams() {
    return _teams;
  }

  @override
  void load(List<Team> teams) {
    _teams.clear();
    _teams.addAll(teams);
  }

  @override
  void addNewTeam(Team team) {
    _teams.add(team);
  }

  @override
  void changeOrder(Team team) {
    // TODO: implement changeOrder
  }

  @override
  Signal<Team> nextIncompleteTeam() {
    return _teams.singleWhere((element) => element.incomplete).asSignal();
  }

}