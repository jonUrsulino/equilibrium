import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/use_case/get_computed_arrived_players.dart';
import 'package:meta/meta.dart';

part 'arrived_players_event.dart';
part 'arrived_players_state.dart';

class ArrivedPlayersBloc extends Bloc<ArrivedPlayersEvent, ArrivedPlayersState> {

  final PresencePlayerRepository repository;
  final GetComputedArrivedPresencePlayers getComputedArrivedPresencePlayers;

  ArrivedPlayersBloc({
    required this.repository,
    required this.getComputedArrivedPresencePlayers
  }) : super(ArrivedPlayersInitial()) {
    on<ArrivedPlayersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  Future<void> close() {
    repository.dispose();
    getComputedArrivedPresencePlayers.dispose();
    return super.close();
  }
}
