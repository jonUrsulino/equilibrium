import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart';

class Settings {
  Settings();

  final maxPlayersByTeam = Signal(7);

  void incMaxPlayersByTeam() {
    maxPlayersByTeam.set(maxPlayersByTeam.value + 1);
  }

  void decMaxPlayersByTeam() {
    maxPlayersByTeam.set(maxPlayersByTeam.value - 1);
  }

  int getMaxPlayersByTeam() => maxPlayersByTeam.value;

  final isBalancedWithGoalkeeper = Signal(true);

  bool isConsideredBalanceWithGoalkeeper() {
    return isBalancedWithGoalkeeper.value;
  }

  final enabledBalanceTeamsOnChangeGame = Signal(true);


  bool isEnabledBalanceTeamsOnChangeGame() {
    return enabledBalanceTeamsOnChangeGame.value;
  }

  final starsVisible = Signal(true);


  void toggleStarsVisible() {
    starsVisible.set(!starsVisible.value);
  }
}
