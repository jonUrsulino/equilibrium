
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/model/shirt.dart';
import 'package:equilibrium/member_team/presentation/member_team_widget.dart';
import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
  const TeamCard(
      Key? key,
      this.shirt,
      this.presencePlayers,
      this.totalStars,
      ): super(key: key);

  final List<PresencePlayer> presencePlayers;
  final Shirt shirt;
  final double totalStars;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _headerTeam(context),
        _teamMembers(),
        const SizedBox(
          height: 20,
        ),
        const Divider(
          height: 1,
        )
      ],
    );
  }

  Container _headerTeam(BuildContext context) {
    return Container(
      color: Theme.of(context).secondaryHeaderColor,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.shield,
              color: shirt.color,
            ),
          ),
          Text(
            shirt.name,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),
          const Spacer(),
          Text('$totalStars',
            style: Theme
                .of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
          const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.star_border,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Container _teamMembers() {
    return Container(
      margin: const EdgeInsets.all(3),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: presencePlayers.length,
        itemBuilder: (context, index) {
          var presencePlayer = presencePlayers[index];
          return MemberTeamWidget(
            Key(presencePlayer.player.name),
            presencePlayer: presencePlayer,
            position: (index + 1).toString(),
          );
        },
      ),
    );
  }

}