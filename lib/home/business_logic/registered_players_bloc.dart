import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/use_case/get_computed_confirmed_players_sort_by_name.dart';
import 'package:equilibrium/domain/use_case/get_computed_presence_players_sorted_by_name.dart';
import 'package:meta/meta.dart';

part 'registered_players_event.dart';
part 'registered_players_state.dart';

class RegisteredPlayersBloc extends Bloc<RegisteredPlayersEvent, RegisteredPlayersState> {
  final PresencePlayerRepository presencePlayerRepository;
  final GetComputedPresencePlayersSortedByName getComputedPresencePlayersSortedByName;
  final GetComputedConfirmedPlayersSortByName getConfirmedPlayersSortByName;

  RegisteredPlayersBloc({
    required this.presencePlayerRepository,
    required this.getComputedPresencePlayersSortedByName,
    required this.getConfirmedPlayersSortByName
  }) : super(RegisteredPlayersInitial()) {
    on<RegisteredPlayersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  Future<void> close() {
    presencePlayerRepository.dispose();
    getConfirmedPlayersSortByName.dispose();
    getComputedPresencePlayersSortedByName.dispose();
    return super.close();
  }
}
