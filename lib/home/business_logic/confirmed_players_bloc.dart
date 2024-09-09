import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:meta/meta.dart';

part 'confirmed_players_event.dart';
part 'confirmed_players_state.dart';

class ConfirmedPlayersBloc extends Bloc<ConfirmedPlayersEvent, ConfirmedPlayersState> {
  final PresencePlayerRepository repository;

  ConfirmedPlayersBloc({
    required this.repository,
  }) : super(ConfirmedPlayersInitial()) {
    on<ConfirmedPlayersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  Future<void> close() {
    repository.dispose();
    return super.close();
  }
}
