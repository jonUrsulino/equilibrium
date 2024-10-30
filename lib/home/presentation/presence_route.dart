import 'package:equilibrium/home/business_logic/presence_bloc.dart';
import 'package:equilibrium/home/presentation/presence_screen.dart';
import 'package:equilibrium/presentation/model/bottom_navigation_type.dart';
import 'package:equilibrium/presentation/screen/main_container.dart';
import 'package:equilibrium/presentation/screen/new_player_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class PresenceRoute extends StatelessWidget {
  static var route = "/";

  const PresenceRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PresenceBloc(
          repository: GetIt.I.get()
      ),
      child: BlocConsumer<PresenceBloc, PresenceState>(
          listener: (context, state) {
            if (state is AddPlayerPresenceState) {
              _addPlayers(context);
            }
          },
          builder: (context, state) {
            if (state is! PresenceLengthState) {
              return Container();
            }

            final PresenceBloc bloc = context.read();
            var arrivedPlayersLength = state.lengthArrivedPlayers;

            return MainContainer(
                title: _buildTitle(arrivedPlayersLength),
                floatingActionButton: _buildFAB(bloc),
                currentBottomNavigation: BottomNavigationType.home,
                child: const PresenceScreen()
            );
          }
      ),
    );
  }

  String _buildTitle(int arrivedPlayersLength) {
    return 'Presence: $arrivedPlayersLength';
  }

  FloatingActionButton _buildFAB(PresenceBloc bloc) => FloatingActionButton(
    shape: const CircleBorder(),
    onPressed: () => bloc.add(AddPlayerPresenceEvent()),
    child: const Icon(Icons.add_circle_outlined),
  );

  void _addPlayers(BuildContext context) {
    print("add new player");

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const NewPlayerDialog();
      },
    );
  }
}