import 'package:flutter/material.dart';

final ValueNotifier<int> selectedvalueNotifier = ValueNotifier<int>(0);

// For current playing song
final ValueNotifier<Map<String, String>> currentSongNotifier = ValueNotifier({});

ValueNotifier<bool> isbrightNotifier = ValueNotifier(false);
class kconstants{
  static const String themeModekey = 'themeModekey';
}