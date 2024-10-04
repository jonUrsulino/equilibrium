

import 'package:equilibrium/domain/model/player.dart';
import 'package:equilibrium/domain/repository/player_repository.dart';
import 'package:signals/signals.dart';

class PlayerRepositoryImpl implements PlayerRepository {

  final players = ListSignal([
    Player.normal("Tiago Valadão", 5),
    Player.normal("Jocivaldo", 5),
    Player.normal("Victor", 5),
    Player.normal("Kennedy", 5),
    Player.normal("Jonathan", 4.5),
    Player.normal("Isaias", 4.5),
    Player.normal("Eli", 4.5),
    Player.normal("Caio", 4.5),
    Player.normal("Pr. Wilson", 4),
    Player.normal("Tchuco", 4),
    Player.normal("Carlos", 4),
    Player.normal("Ismael", 3.5),
    Player.normal("Henrique", 3.5),
    Player.normal("Danilo", 3.5),
    Player.normal("Rubens", 3),
    Player.normal("Alifer", 3),
    Player.normal("Phelip", 3),
    Player.normal("Davi Bispo", 2.5),
    Player.normal("Adriano Bispo", 2.5),
    Player.normal("Igão", 2.5),
    Player.normal("Edmilson", 2.5),
    Player.normal("Davi Benatti", 2),
    Player.normal("Mike", 2),
    Player.normal("Haroldo", 2),
    Player.normal("Gustavo", 2),
    Player.normal("Nino", 1.5),
    Player.normal("Samuelzinho", 1.5),
    Player.normal("Rafa", 1.5),
    Player.normal("Kevin", 1.5),
    Player.normal("Fabinho", 1.0),
    Player.normal("Pr. Silvano", 1.0),
    Player.normal("Bino", 1.0),

    Player.normal("Ancelmo", 2),
    Player.goalkeeper("Murilo", 5),
    Player.goalkeeper("Fabio Benatti", 2.5),
    Player.normal("Samuel", 4.5),
    Player.normal("Pr. Moacyr", 2.5),
    Player.normal("Marcos", 3.5),
    // Player.normal("Breno", 4),
  ]);

  @override
  ListSignal<Player> getPlayers() {
    return players;
  }


}