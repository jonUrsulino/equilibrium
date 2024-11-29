import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pair/pair.dart';

class Shirt {
  String name;
  Color color;

  Shirt._(this.name, this.color);

  factory Shirt.orange() {
    return Shirt._(_orange.key, _orange.value);
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
  factory Shirt.white() {
    return Shirt._(_white.key, _white.value);
  }
  factory Shirt.undefined() {
    return Shirt._(_undefined.key, _undefined.value);
  }

  static const _black = Pair("Preto", Colors.black38);
  static const _orange = Pair("Laranja", Colors.orange);
  static const _green = Pair("Verde", Colors.lightGreen);
  static const _blue = Pair("Azul", Colors.blue);
  static const _white = Pair("Branco", Colors.white70);
  static const _undefined = Pair("Indefinido", Colors.brown);

  @override
  String toString() {
    return name;
  }
}
