import 'package:equilibrium/domain/model/game.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/game/business_logic/game_bloc.dart';
import 'package:equilibrium/game/presentation/game_card.dart';
import 'package:equilibrium/presentation/screen/team_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    required this.bloc,
    super.key
  });

  final GameBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        print("state $state");

        switch (state) {
          case GameInitial():
            return const CircularProgressIndicator();
          case GameLoad():
            return SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                  children: [
                    _buildCardGame(context),
                    const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Próximos')
                    ),
                    _nextTeams(context)
                  ]
              ),
            );
        }
      },
    );
  }

  Widget _buildCardGame(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          switch (state) {
            case GameInitial():
              return const CircularProgressIndicator();

            case GameLoad():
              final List<Team> teams = state.nextTeams;
              final Game game = state.game;

              print("game ${game.teamA.shirt.name} ${game.teamB.shirt.name}");

              for (Team team in teams) {
                print("Team Card BlocBuilder: ${team.shirt.name}");
              }

              return GameCard(
                game: game,
                presencePlayerRepository: bloc.presencePlayerRepository,
                function: (Team team, SideTeam sideTeam) {
                  bloc.add(ChangeLoseTeamEvent(loserTeam: team, sideTeam: sideTeam));
                },
              );
          }
        }
    );
  }

  Widget _nextTeams(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        switch (state) {
          case GameInitial():
            return const CircularProgressIndicator();

          case GameLoad():
            final List<Team> teams = state.nextTeams;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    var team = teams[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TeamCard(
                        Key(team.shirt.name),
                        team.shirt,
                        team.actualPresencePlayers(bloc.presencePlayerRepository),
                        team.calculatePower(),
                      ),
                    );
                  }),
            );
        }
      },
    );
  }

  onRemoveTeam(Team team, SideTeam sideTeam) {
    bloc.add(ChangeLoseTeamEvent(loserTeam: team, sideTeam: sideTeam));
  }
}