import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/repository/team_repository.dart';
import 'package:meta/meta.dart';
import 'package:signals/signals.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {

  final PresencePlayerRepository repository;
  final TeamRepository teamRepository;

  BalanceBloc({required this.teamRepository, required this.repository}) : super(BalanceInitial()) {
    on<BalanceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  late final arrivedPlayersSignals = repository.getComputedArrivedPresencePlayers();
  late final teamsSignal = computed(() => teamRepository.getTeams());

  @override
  Future<void> close() {
    arrivedPlayersSignals.dispose();
    teamsSignal.dispose();
    return super.close();
  }
}
