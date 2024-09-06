
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/use_case/get_initial_players_sort_by_name.dart';

class GetPresencePlayersMappedWithNames {
  GetPresencePlayersMappedWithNames({required this.useCase});

  final GetInitialPresencePlayersSortByNames useCase;

  Map<String, PresencePlayer> execute() {
    List<PresencePlayer> list = useCase.execute();
    return { for (var h in list) h.player.name : h };
  }
}