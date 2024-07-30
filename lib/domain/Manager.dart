import 'package:equilibrium/domain/coach.dart';
import 'package:equilibrium/domain/team.dart';
import 'package:pair/pair.dart';

class Manager {
  Manager();

  void balance() {
    List<Pair<int, Coach>> training = [];
    for (int i = 0; i < 3; i++) {
      final coach = Coach();
      coach.balanceTeams();
      coach.printTeams();

      training.add(Pair(i, coach));
    }
  }
}
