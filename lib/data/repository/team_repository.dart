
import 'package:equilibrium/domain/model/shirt.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/domain/repository/team_repository.dart';
import 'package:flutter/foundation.dart';
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
  void changeOrder(List<Team> newOrderTeams) {

    for (Team eita in newOrderTeams) {
      print("repository ${eita.shirt.name}");
    }

    _teams.overrideWith(newOrderTeams);
  }

  @override
  Signal<Team> nextIncompleteTeam() {
    return _teams.singleWhere((element) => element.incomplete).asSignal();
  }

  @override
  Signal<Team> getTeamByShirt(Shirt shirt) {
    return _teams.singleWhere((element) => element.shirt == shirt).asSignal();
  }

  @override
  ListSignal<Team> getNextTeams() {
    return ListSignal(_teams.value.getRange(2, _teams.value.length).toList());
  }

  @override
  Computed<Team> first() {
    return computed(() => _teams[0]);
  }

  @override
  Computed<Team> second() {
    return computed(() => _teams[1]);
  }

}