import 'dart:ui';

import 'package:pair/pair.dart';

class Shirt {
  String name;
  Color color;

  Shirt._(this.name, this.color);

  factory Shirt.white() {
    return Shirt._(_white.key, _white.value);
  }
  factory Shirt.black() {
    return Shirt._(_black.key, _black.value);
  }
  factory Shirt.green() {
    return Shirt._(_green.key, _green.value);
  }
  factory Shirt.blue() {
    return Shirt._(_blue.key, _blue.value);
  }
  factory Shirt.undefined() {
    return Shirt._(_undefined.key, _undefined.value);
  }

  static const _white = Pair("white", Color(0xFFFFFFFF));
  static const _black = Pair("black", Color(0xFF000000));
  static const _green = Pair("green", Color(0xFF00FF00));
  static const _blue = Pair("blue", Color(0xFF0000FF));
  static const _undefined = Pair("undefined", Color(0xFF674836));
}
