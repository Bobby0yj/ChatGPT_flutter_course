import 'dart:ui';
import 'package:flutter/material.dart';

 List<Color> noteColors = [
  Color(0xFFFD99FF),
  Color(0xFFFF9E9E),
  Color(0xFF91F48F),
  Color(0xFFFFF599),
  Color(0xFF9EFFFF),
  Color(0xFFB69CFF),
  Colors.orange.shade300,
  Colors.blue.shade300,
];

class ColorProvider with ChangeNotifier{

  final List<Color> _colors = noteColors;
  List<Color> get colors => _colors;

  Color _bgColor = const Color(0xFF252525);
  Color get bgColor => _bgColor;

  setBgColor(Color color){
    _bgColor = color;
    notifyListeners();
  }

}