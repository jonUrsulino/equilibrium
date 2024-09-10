
import 'package:equilibrium/domain/model/shirt.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:signals/signals.dart';

abstract class TeamRepository {
  ListSignal<Team> getTeams();
  void load(List<Team> teams);
  void addNewTeam(Team team);
  void changeOrder(List<Team> newOrderTeams);
  Computed<Team> first();
  Computed<Team> second();

  Signal<Team> nextIncompleteTeam();

  Signal<Team> getTeamByShirt(Shirt shirt);
  ListSignal<Team> getNextTeams();
}