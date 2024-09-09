import 'package:equilibrium/member_team/business_logic/member_team_bloc.dart';
import 'package:equilibrium/member_team/presentation/member_team_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class MemberTeamComponent extends StatelessWidget {
  const MemberTeamComponent({
    required this.position,
    required this.playerName,
    super.key
  });

  final String position;
  final String playerName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MemberTeamBloc(
          position: position,
          playerName: playerName,
          repository: GetIt.I.get()
      ),
      child: Watch((context) {
        final MemberTeamBloc bloc = context.read();
        var presencePlayer = bloc.presencePlayerSignal.value;
        return MemberTeamWidget(
          presencePlayer: presencePlayer,
          position: bloc.position,
          settings: bloc.settings,
        );
      },),
    );
  }
}