import 'package:flutter/material.dart';

class Options {
  final String img;
  final String title;
  final Color color;
  Options(this.img, this.title, this.color);
}

List<Options> optionsList = [
  Options("images/brain.svg", "Quick Play", Colors.deepOrange),
  Options("images/level.svg", "Levels", Colors.blueAccent),
  Options("images/crown_outlined.svg", "Leaderboard", Colors.orange),
];
