import 'package:equilibrium/domain/model/game.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/model/team.dart';
import 'package:equilibrium/game/business_logic/game_bloc.dart';
import 'package:equilibrium/member_team/presentation/member_team_widget.dart';
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
    print("INIT");

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

              return Card(
                shape: const RoundedRectangleBorder(),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    color: Colors.white10,
                    child: Row(
                      children: [
                        _buildTeam(context, game.teamA, SideTeam.teamA),
                        _buildTeam(context, game.teamB, SideTeam.teamB)
                      ],
                    ),
                  ),
                ),
              );
          }
        }
    );
  }

  Widget _buildTeam(BuildContext context, Team team, SideTeam sideTeam) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _headerTeam(context, team, sideTeam),
            _teamMembers(context, team.players, sideTeam),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
    //     }
    //   },
    // );
  }

  Widget _teamMembers(BuildContext context, List<PresencePlayer> players, SideTeam sideTeam) {
    // final GameBloc bloc = context.read();
    // Computed<List<PresencePlayer>> playerBySide = bloc.getPlayerBySide(
    //     sideTeam);

    return Container(
      margin: const EdgeInsets.all(3),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: players.length,
        itemBuilder: (context, index) {
          var presencePlayer = players[index];
          return MemberTeamWidget(
            Key(presencePlayer.player.name),
            presencePlayer: presencePlayer,
            position: "${index + 1}. ",
          );

        },
      ),
    );
  }

  Widget _headerTeam(BuildContext context, Team team, SideTeam sideTeam) {
    return Container(
      color: Theme
          .of(context)
          .secondaryHeaderColor,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.shield,
              color: team.shirt.color,
            ),
          ),
          Text(
            team.shirt.name,
            style: Theme
                .of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),
          IconButton(
            onPressed: () => onRemoveTeam(team, sideTeam),
            icon: const Icon(Icons.change_circle),
            tooltip: "Perdeu",
          ),
          const Spacer(),
          const Icon(
            Icons.star_border,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${team.calculatePower()}',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
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
                          team
                      ),
                    );
                  }),
            );
        }
      },
    );
  }

  onRemoveTeam(Team team, SideTeam sideTeam) {
    print('onRemoveTeam ${team.shirt.name}');
    bloc.add(ChangeLoseTeamEvent(loserTeam: team, sideTeam: sideTeam));
  }
}

enum SideTeam {
  teamA,
  teamB
}