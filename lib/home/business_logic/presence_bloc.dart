import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:meta/meta.dart';

part 'presence_event.dart';
part 'presence_state.dart';

class PresenceBloc extends Bloc<PresenceEvent, PresenceState> {

  final PresencePlayerRepository repository;

  PresenceBloc({required this.repository}) : super(PresenceInitial()) {

    _loadListen();

    on<AddPlayerPresenceEvent>((event, emit) {
      emit.call(AddPlayerPresenceState());
    });
  }

  // late final arrivedPlayersSignals = repository.getComputedArrivedPresencePlayers();

  void _loadListen() async {
    final lengthArrivedPlayersStream = repository.getStreamLengthPresencePlayersWhere(StatePresence.arrived);
    await for (int length in lengthArrivedPlayersStream) {
      emit(PresenceLengthState(length));
    }
  }
}
