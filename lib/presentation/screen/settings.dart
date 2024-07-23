import 'package:equilibrium/domain/settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  static const route = 'SettingsScreen';

  final maxPlayersController = TextEditingController();
  final settings = GetIt.I.get<Settings>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Text(
            'Preferências',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Column(
            children: [
              Row(
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
              ),
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
    );
  }
}
