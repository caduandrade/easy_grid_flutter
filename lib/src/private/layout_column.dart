import 'package:easy_grid/easy_grid.dart';
import 'package:easy_grid/src/axis_alignment.dart';
import 'package:flutter/widgets.dart';

class LayoutColumn {
  factory LayoutColumn(GridColumn column) {
    return LayoutColumn._(alignment: column.alignment);
  }

  LayoutColumn._({required this.alignment});

  List<RenderBox> children = [];

  final AxisAlignment alignment;

  double _width = 0;
  double get width => _width;
  set width(double value) {
    _width = value;
    if (value < 0) {
      throw ArgumentError('Invalid width: $value');
    }
  }

  double x = 0;
}
