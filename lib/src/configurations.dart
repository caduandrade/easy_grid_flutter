import 'package:flutter/widgets.dart';

class EasyGridConfiguration {
  EasyGridConfiguration(
      {this.row,
      this.column,
      required this.spanX,
      required this.spanY,
      required this.wrap,
      required this.growX,
      required this.growY,
      required this.skip,
      required this.alignment});

  final int? row;
  final int? column;
  final int spanX;
  final int spanY;
  final bool wrap;
  final bool growX;
  final bool growY;
  final int skip;
  final Alignment alignment;
}
