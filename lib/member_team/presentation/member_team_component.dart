import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/member_team/business_logic/member_team_bloc.dart';
import 'package:equilibrium/member_team/presentation/member_team_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class MemberTeamComponent extends StatelessWidget {
  const MemberTeamComponent({
    required this.position,
    required this.presencePlayer,
    super.key
  });

  final String position;
  final PresencePlayer presencePlayer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MemberTeamBloc(
              position: position,
              playerName: presencePlayer.player.name,
              repository: GetIt.I.get()
          ),
      child: BlocBuilder<MemberTeamBloc, MemberTeamState>(
        builder: (context, state) {
          final MemberTeamBloc bloc = context.read();
          PresencePlayer? presencePlayer = bloc.presencePlayerSignal.value;
          presencePlayer ??= this.presencePlayer;
          print('member builder presence: $presencePlayer');
          print('member builder presence name: ${presencePlayer.player.name}');
          return MemberTeamWidget(
            presencePlayer: presencePlayer,
            position: bloc.position,
            settings: bloc.settings,
          );
        },
      ),
    );
  }
}