import 'package:bloc/bloc.dart';
import 'package:equilibrium/domain/controller_manager.dart';
import 'package:equilibrium/domain/model/game.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:equilibrium/domain/repository/team_repository.dart';
import 'package:equilibrium/domain/settings.dart';
import 'package:equilibrium/game/presentation/game_screen.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {

  final ControllerManager controller;
  final TeamRepository teamRepository;
  final PresencePlayerRepository presencePlayerRepository;
  final Settings settings;

  GameBloc({
    required this.presencePlayerRepository,
    required this.teamRepository,
    required this.controller,
    required this.settings
  }) : super(GameInitial()) {

    on<LoadGameEvent>((event, emit) {
      onLoadGame(emit);
    });

    on<ChangeLoseTeamEvent>((event, emit) {
      onChangeLoseTeam(event, emit);
    });
  }

  void onChangeLoseTeam(ChangeLoseTeamEvent event, Emitter<GameState> emit) {
    print("ChangeLoseTeamEvent ${event.sideTeam}");
    controller.recreateManagerGame(event.loserTeam, event.sideTeam);
    var game = controller.managerGame.game;

    emit(GameLoad(
        game: game,
        nextTeams: controller.nextTeams,
    ));
  }

  void onLoadGame(Emitter<GameState> emit) {
    print("GameEvent");
    controller.initManagerGame();
    var game = controller.managerGame.game;
    emit(GameLoad(
        game: game,
        nextTeams: controller.nextTeams
    ));
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
