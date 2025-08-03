import 'package:flutter/material.dart';

extension ColorShade on Color {
  /// Returns a darker shade of this color.
  /// [by] from 0.0 → 1.0 (0.0 = no change, 1.0 = black).
  Color darken({double by = 0.9}) {
    assert(by >= 0 && by <= 1);
    final f = 1 - by;

    // Flutter 3.0+: use .a/.r/.g/.b (each returns double 0.0–1.0)
    final aInt = (a * 255.0).round() & 0xff;
    final rInt = (r * 255.0).round() & 0xff;
    final gInt = (g * 255.0).round() & 0xff;
    final bInt = (b * 255.0).round() & 0xff;

    final newR = (rInt * f).round().clamp(0, 255);
    final newG = (gInt * f).round().clamp(0, 255);
    final newB = (bInt * f).round().clamp(0, 255);

    return Color.fromARGB(aInt, newR, newG, newB);
  }
}
