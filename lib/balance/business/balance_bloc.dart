import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:meta/meta.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {

  final Coach coach;
  final PresencePlayerRepository repository;

  BalanceBloc({required this.coach, required this.repository}) : super(BalanceInitial()) {
    on<BalanceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  Future<void> close() {
    repository.dispose();
    return super.close();
  }
}
