import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:meta/meta.dart';

part 'presence_event.dart';
part 'presence_state.dart';

class PresenceBloc extends Bloc<PresenceEvent, PresenceState> {

  final PresencePlayerRepository repository;

  PresenceBloc({required this.repository}) : super(PresenceInitial()) {
    on<PresenceEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<AddPlayerPresenceEvent>((event, emit) {
      emit.call(AddPlayerPresenceState());
    });
  }


  late final arrivedPlayersSignals = repository.getComputedArrivedPresencePlayers();
}
