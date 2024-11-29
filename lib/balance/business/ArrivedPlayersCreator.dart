

import 'dart:async';

import 'package:equilibrium/domain/model/presence_player.dart';

class ArrivedPlayersCreator {
  ArrivedPlayersCreator(Stream<List<PresencePlayer>> streamArrived) {
    _controller.sink.addStream(streamArrived);
  }

  final List<PresencePlayer> _list = List.empty(growable: true);

  final _controller = StreamController<List<PresencePlayer>>();

  Stream<List<PresencePlayer>> get stream => _controller.stream;

  List<PresencePlayer> get cachePresencePlayers => _list;
}