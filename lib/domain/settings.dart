import 'package:signals/signals.dart';

class Settings {
  Settings();

  final maxPlayersByTeam = Signal(6);

  void incMaxPlayersByTeam() {
    maxPlayersByTeam.set(maxPlayersByTeam.value + 1);
  }

  void decMaxPlayersByTeam() {
    maxPlayersByTeam.set(maxPlayersByTeam.value - 1);
  }

  int getMaxPlayersByTeam() => maxPlayersByTeam.value;
}
