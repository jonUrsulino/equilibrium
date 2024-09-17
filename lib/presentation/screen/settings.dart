import 'package:equilibrium/domain/settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key,});

  static const route = 'SettingsScreen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Settings settings = GetIt.I.get();
  final TextEditingController maxPlayersController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.abc),
          onPressed: () {
        print("OI");
      }),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              children: [
                buildRowDecInc(context),
                Row(
                  children: [
                    Text(
                      'Considerar goleiros no balanceamento',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Checkbox(
                      value: settings.isBalancedWithGoalkeeper.watch(context),
                      onChanged: (value) =>
                          settings.isBalancedWithGoalkeeper.set(value!),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRowDecInc(BuildContext context) {
    return Row(
      children: [
        Text(
          'Máximo de jogadores por time',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        IconButton(
          onPressed: () => settings.decMaxPlayersByTeam(),
          icon: const Icon(
            Icons.exposure_minus_1,
          ),
        ),
        Text(
          '${settings.maxPlayersByTeam.watch(context)}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        IconButton(
          onPressed: () => settings.incMaxPlayersByTeam(),
          icon: const Icon(
            Icons.exposure_plus_1,
          ),
        ),
      ],
    );
  }
}
