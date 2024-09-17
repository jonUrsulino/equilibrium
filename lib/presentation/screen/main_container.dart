
import 'package:equilibrium/balance/presentation/balance_route.dart';
import 'package:equilibrium/game/presentation/game_route.dart';
import 'package:equilibrium/home/business_logic/home_bloc.dart';
import 'package:equilibrium/home/presentation/presence_route.dart';
import 'package:equilibrium/navigator/app_navigator.dart';
import 'package:equilibrium/presentation/model/bottom_navigation_type.dart';
import 'package:equilibrium/presentation/screen/canceling_confirmation_bottom_sheet.dart';
import 'package:equilibrium/settings/presentation/settings.dart';
import 'package:equilibrium/raffle_players/presentation/raffle_players_widget.dart';
import 'package:equilibrium/settings/presentation/settings_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({
    required this.title,
    required this.child,
    required this.currentBottomNavigation,
    this.floatingActionButton,
    super.key,
  });

  final Widget child;
  final String title;
  final FloatingActionButton? floatingActionButton;
  final BottomNavigationType currentBottomNavigation;

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {

  late HomeBloc bloc;
  final AppNavigator navigator = GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    bloc = context.read<HomeBloc>();

    return Scaffold(
      appBar: _buildAppBar(widget.title, context),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: widget.child,
      bottomNavigationBar: _buildBottomAppBar(bloc, context),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  AppBar _buildAppBar(String title, BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      actions: [
        IconButton(
          onPressed: () => _onTapVisibleButtons(),
          icon: Icon(bloc.settings.starsVisible.watch(context)
              ? Icons.visibility
              : Icons.visibility_off),
        ),
        IconButton(
          onPressed: () => _onTapSortPlayers(context),
          icon: const Icon(Icons.published_with_changes),
        ),
        IconButton(
          onPressed: () => _onTapCheckPresence(context),
          icon: const Icon(Icons.check),
        ),
      ],
    );
  }

  BottomAppBar _buildBottomAppBar(HomeBloc bloc, BuildContext context) {
    const MaterialColor selectedIconColor = Colors.green;

    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            isSelected: isSelected(BottomNavigationType.home),
            selectedIcon: const Icon(
              Icons.directions_run,
              color: selectedIconColor,
            ),
            tooltip: "Jogadores",
            icon: const Icon(
              Icons.directions_run,
              color: Colors.black,
            ),
            onPressed: () => onTapBottomNavigation(bloc, BottomNavigationType.home),
          ),
          IconButton(
            isSelected: isSelected(BottomNavigationType.balance),
            tooltip: "Times",
            selectedIcon: const Icon(
              Icons.groups,
              color: selectedIconColor,
            ),
            icon: const Icon(
              Icons.groups,
              color: Colors.black,
            ),
            onPressed: () => onTapBottomNavigation(bloc, BottomNavigationType.balance),
          ),
          IconButton(
            isSelected: isSelected(BottomNavigationType.game),
            tooltip: "Partida",
            selectedIcon: const Icon(
              Icons.sports_soccer,
              color: selectedIconColor,
            ),
            icon: const Icon(
              Icons.sports_soccer,
              color: Colors.black,
            ),
            onPressed: () => onTapBottomNavigation(bloc, BottomNavigationType.game),
          ),
          IconButton(
            isSelected: isSelected(BottomNavigationType.settings),
            tooltip: "Ajustes",
            selectedIcon: const Icon(
              Icons.settings,
              color: selectedIconColor,
            ),
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () => onTapBottomNavigation(bloc, BottomNavigationType.settings),
          ),
        ],
      ),
    );
  }

  void onTapBottomNavigation(HomeBloc bloc, BottomNavigationType type) {
    bloc.bottomNavAction.set(type);

    switch (type) {
      case BottomNavigationType.home:
        navigator.navigateToScreenAndClearBackStack(name: PresenceRoute.route);
      case BottomNavigationType.balance:
        navigator.navigateToScreenAndClearBackStack(name: BalanceRoute.route);
      case BottomNavigationType.game:
        navigator.navigateToScreenAndClearBackStack(name: GameRoute.route);
      case BottomNavigationType.settings:
        navigator.navigateToScreenAndClearBackStack(name: SettingsRoute.route);
    }
  }

  void _onTapVisibleButtons() {
    bloc.settings.toggleStarsVisible();
  }

  void _onTapSortPlayers(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return const RafflePlayersWidget();
      },
    );
  }

  void _onTapCheckPresence(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return CancelingConfirmationBottomSheet(
          repository: GetIt.I.get(),
        );
      },
    );
  }

  isSelected(BottomNavigationType type) => type == widget.currentBottomNavigation;
}