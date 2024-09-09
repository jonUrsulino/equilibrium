import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/model/presence_player.dart';
import 'package:equilibrium/domain/repository/presence_player_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class NewPlayerDialog extends StatefulWidget {
  const NewPlayerDialog({super.key});

  @override
  State<NewPlayerDialog> createState() => _NewPlayerDialogState();
}

class _NewPlayerDialogState extends State<NewPlayerDialog> {
  final PresencePlayerRepository repository = GetIt.I.get();
  final Signal<double> stars = Signal(3);
  final Signal<bool?> isGoalkeeper = Signal(false);
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    effect(() => print('Estrelas $stars'));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
          const Text('Novo jogador'),
          TextField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            autofocus: true,
            controller: textEditingController,
          ),
          Row(
            children: [
              Text(
                'É goleiro',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Checkbox(
                value: isGoalkeeper.watch(context),
                onChanged: (value) => isGoalkeeper.set(value),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RatingStars(
              value: stars.watch(context),
              maxValue: 5,
              starSize: 25,
              starColor: Colors.amber,
              onValueChanged: (v) {
                stars.set(v);
              },
            ),
          ),
          TextButton(
            child: const Text('Adicionar'),
            onPressed: () {
              onPressedAddPlayer(context);
            },
          ),
        ]),
    );
  }

  void onPressedAddPlayer(BuildContext context) {
    final playerName = textEditingController.text;
    final rating = stars.value;
    final isGoalkeeper = this.isGoalkeeper.value ?? false;
    repository.addNewPlayer(
      PresencePlayer.initial(
        Player(playerName, rating, isGoalkeeper),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Jogador $playerName criado. Estrelas: $rating",
        ),
      ),
    );
  }
}
