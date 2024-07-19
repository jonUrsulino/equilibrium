import 'dart:ui';

import 'package:equilibrium/domain/home_arriving_player.dart';
import 'package:equilibrium/domain/player.dart';
import 'package:equilibrium/domain/presence.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:signals/signals_flutter.dart';

class NewPlayerDialog extends StatelessWidget {
  NewPlayerDialog({super.key});

  final PresencePlayers presence = GetIt.I.get();
  final Signal<double> stars = Signal(3);
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    effect(() => print('Estrelas $stars'));
    return AlertDialog.adaptive(
      scrollable: true,
      contentPadding: EdgeInsets.all(8),
      title: const Text('Novo jogador'),
      content: Column(children: [
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
        )
      ]),
      actions: <Widget>[
        TextButton(
          child: const Text('Adicionar'),
          onPressed: () {
            var playerName = textEditingController.text;
            var rating = stars.value;
            presence.addNewPlayer(
              HomeArrivingPlayer(
                Player(
                  playerName,
                  rating,
                ),
                rating,
                false,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Jogador $playerName criado. Estrelas: $rating",
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
