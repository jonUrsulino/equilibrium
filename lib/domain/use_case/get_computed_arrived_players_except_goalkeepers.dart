
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/use_case/get_computed_arrived_players.dart';
import 'package:signals/signals.dart';

class GetComputedArrivedPresencePlayersExceptGoalkeepers {
  GetComputedArrivedPresencePlayersExceptGoalkeepers({required this.useCase});

  final GetComputedArrivedPresencePlayers useCase;

  get _value => computed<List<PresencePlayer>>(() {
    return useCase.execute().get().where((element) {
      return !element.player.isGoalkeeper;
    }).toList();
  });

  Computed<List<PresencePlayer>> execute() {
    return _value;
  }

  void dispose() {
    // useCase.dispose();
  }
}