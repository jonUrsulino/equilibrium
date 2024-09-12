import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/use_case/notify_arrived_player.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'confirmed_players_event.dart';
part 'confirmed_players_state.dart';

class ConfirmedPlayersBloc extends Bloc<ConfirmedPlayersEvent, ConfirmedPlayersState> {
  final PresencePlayerRepository repository;

  late final confirmedPlayersSignals = repository.getComputedConfirmedPresencePlayers();
  final NotifyArrivedPlayer notifyArrivedPlayerUseCase = GetIt.I.get();

  ConfirmedPlayersBloc({
    required this.repository,
  }) : super(ConfirmedPlayersInitial()) {
    on<ConfirmedPlayersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  Future<void> close() {
    confirmedPlayersSignals.dispose();
    return super.close();
  }
}
