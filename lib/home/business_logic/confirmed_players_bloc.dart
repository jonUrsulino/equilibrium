import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/use_case/get_computed_confirmed_players_sort_by_name.dart';
import 'package:meta/meta.dart';

part 'confirmed_players_event.dart';
part 'confirmed_players_state.dart';

class ConfirmedPlayersBloc extends Bloc<ConfirmedPlayersEvent, ConfirmedPlayersState> {
  final PresencePlayerRepository repository;
  final GetComputedConfirmedPlayersSortByName getComputedConfirmedPlayersSortByName;

  ConfirmedPlayersBloc({
    required this.repository,
    required this.getComputedConfirmedPlayersSortByName
  }) : super(ConfirmedPlayersInitial()) {
    on<ConfirmedPlayersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  Future<void> close() {
    repository.dispose();
    getComputedConfirmedPlayersSortByName.dispose();
    return super.close();
  }
}
