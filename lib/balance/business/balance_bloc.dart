import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/use_case/get_computed_arrived_players.dart';
import 'package:meta/meta.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {

  final Coach coach;
  final GetComputedArrivedPresencePlayers getListArrivedPresencePlayers;

  BalanceBloc({required this.coach, required this.getListArrivedPresencePlayers}) : super(BalanceInitial()) {
    on<BalanceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  Future<void> close() {
    getListArrivedPresencePlayers.dispose();
    return super.close();
  }
}
