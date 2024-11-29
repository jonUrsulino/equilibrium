import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equilibrium/balance/business/ArrivedPlayersCreator.dart';
import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/repository/team_repository.dart';
import 'package:meta/meta.dart';
import 'package:signals/signals.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {

  final PresencePlayerRepository repository;
  final TeamRepository teamRepository;
  final Coach coach;

  BalanceBloc({
    required this.teamRepository,
    required this.repository,
    required this.coach,
  }) : super(BalanceInitialState()) {
    on<BalanceLoadEvent>((event, emit) {
      _handleLoadTeams(event, emit);
    });

    on<BalanceTeamsEvent>((event, emit) {
      _handleBalanceTeams(event, emit);
    });
  }

  // late final arrivedPlayersCreator = ArrivedPlayersCreator(
  //     repository.getStreamPresencePlayersWhere(StatePresence.arrived).asBroadcastStream()
  // );
  // late final arrivedPlayersSignals = repository.getComputedArrivedPresencePlayers();
  late final arrivedPlayersStream = repository.getStreamPresencePlayersWhere(StatePresence.arrived).asBroadcastStream();

  late final streamController = StreamController();
  late final teamsSignal = computed(() => teamRepository.getTeams());

  void _handleLoadTeams(BalanceLoadEvent event, Emitter<BalanceState> emit) {
    final List<Team> teams = teamsSignal.value;
    print('teams empty ${teams.isEmpty}');

    for (var team in teams) {
      print('team ${team.shirt.name}');
      for (var player in team.players) {
        print('team repository player ${player.name}');
      }
    }

    if (teams.isEmpty) {
      emit.forEach(arrivedPlayersStream, onData: (player) => NotBalancedState(player));
      // emit.call(NotBalancedState(arrivedPlayersSignals.value));
    } else {
      arrivedPlayersStream.forEach(print);

      final Map<Team, List<PresencePlayer>> mapTeamsPresencePlayers = {
        for (Team e in teams) e : e.actualPresencePlayers(repository)
      };
      emit.forEach(arrivedPlayersStream, onData: (p) => BalancedTeamsState(mapTeamsPresencePlayers));
      // emit.call(BalancedTeamsState(mapTeamsPresencePlayers));

    }
  }

  void _handleBalanceTeams(BalanceTeamsEvent event, Emitter<BalanceState> emit) {
    coach.balanceTeams(event.single);
    coach.printTeams();

    final List<Team> teams = teamsSignal.value;
    final Map<Team, List<PresencePlayer>> mapTeamsPresencePlayers = {
      for (Team e in teams) e : e.actualPresencePlayers(repository)
    };
    print("Aqui");
    emit.call(BalancedTeamsState(mapTeamsPresencePlayers));
  }

  @override
  Future<void> close() {
    // arrivedPlayersSignals.dispose();
    teamsSignal.dispose();
    return super.close();
  }
}
