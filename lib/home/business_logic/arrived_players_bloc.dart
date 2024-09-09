import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:meta/meta.dart';

part 'arrived_players_event.dart';
part 'arrived_players_state.dart';

class ArrivedPlayersBloc extends Bloc<ArrivedPlayersEvent, ArrivedPlayersState> {

  final PresencePlayerRepository repository;

  late final arrivedPlayersSignals = repository.getComputedArrivedPresencePlayers();

  ArrivedPlayersBloc({
    required this.repository,
  }) : super(ArrivedPlayersInitial()) {
    on<ArrivedPlayersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  Future<void> close() {
    arrivedPlayersSignals.dispose();
    return super.close();
  }
}
