import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:signals_core/src/core/signals.dart';

part 'member_team_event.dart';
part 'member_team_state.dart';

class MemberTeamBloc extends Bloc<MemberTeamEvent, MemberTeamState> {
  final PresencePlayerRepository repository;
  final String playerName;
  final String position;

  MemberTeamBloc({
    required this.position,
    required this.playerName,
    required this.repository
  }) : super(MemberTeamInitial()) {
    on<MemberTeamEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final Settings settings = GetIt.I.get();

  late final Computed<PresencePlayer?> presencePlayerSignal = repository.getComputedPlayerByName(playerName);

  @override
  Future<void> close() {
    presencePlayerSignal.dispose();
    return super.close();
  }

}
