
import 'package:equilibrium/data/data_source/local/player_data_source.dart';
import 'package:equilibrium/domain/model/player.dart';

class StorePlayerDataSource implements PlayerDataSource {
  StorePlayerDataSource() {
    _loadData();
  }

  @override
  List<Player> getPlayersStored() {
    var list = Player.store.list();
    print('getPlayersStored: $list');
    return list;
  }

  void _loadData() {
    print('loadData');
    List<Player> allPlayersRegistered = [
      Player.goalkeeper("Murilo", 5),
      Player.normal("Tiago Valadão", 5),
      Player.normal("Jocivaldo", 5),
      Player.normal("Isaias", 4.5),
      Player.normal("Jonathan", 4.5),
      Player.normal("Kennedy", 4.5),
      Player.normal("Eli", 4.5),
      Player.normal("Pr. Wilson", 4.5),
      Player.normal("Henrique", 4),
      Player.normal("Carlos", 4),
      Player.normal("Danilo", 4),
      Player.normal("Rubens", 3.5),
      Player.normal("Tchuco", 3.5),
      Player.normal("Phelip", 3.5),
      Player.normal("Ismael", 3),
      Player.normal("Davi Bispo", 3),
      Player.normal("Adriano Bispo", 3),
      Player.normal("Igão", 3),
      Player.goalkeeper("Fabio Benatti", 3),
      Player.normal("Edmilson", 2.5),
      Player.normal("Ancelmo", 2.5),
      Player.normal("Davi Benatti", 2.5),
      Player.normal("Mike", 2.5),
      Player.normal("Nino", 2),
      Player.normal("Samuelzinho", 2),
      Player.normal("Rafa", 2),
      Player.normal("Kevin", 2),
      Player.normal("Haroldo", 2),
      Player.normal("Fabinho", 1.0),
      Player.normal("Pr. Silvano", 1.0),
      Player.normal("Bino", 1.0),
      Player.normal("Samuel", 4.5),
      Player.normal("Alifer", 3.5),
      Player.normal("Pr. Moacyr", 2.5),
      Player.normal("Marcos", 3.5),
      Player.normal("Caio", 4.5),
      Player.normal("Gustavo", 2),
    ];
    for (var playerStore in allPlayersRegistered) {
      Player.store.save(playerStore);
    }
  }
}