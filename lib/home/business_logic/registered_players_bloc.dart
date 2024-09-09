import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:meta/meta.dart';

part 'registered_players_event.dart';
part 'registered_players_state.dart';

class RegisteredPlayersBloc extends Bloc<RegisteredPlayersEvent, RegisteredPlayersState> {
  final PresencePlayerRepository presencePlayerRepository;

  RegisteredPlayersBloc({
    required this.presencePlayerRepository,
  }) : super(RegisteredPlayersInitial()) {
    on<RegisteredPlayersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  Future<void> close() {
    presencePlayerRepository.dispose();
    return super.close();
  }
}
