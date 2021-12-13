import 'package:easy_grid/src/axis_alignment.dart';
import 'package:easy_grid/src/grid_row.dart';

class LayoutRow {
  factory LayoutRow(GridRow row) {
    return LayoutRow._(alignment: row.alignment);
  }

  LayoutRow._({required this.alignment});

  final AxisAlignment alignment;

  double _height = 0;
  double get height => _height;
  set height(double value) {
    _height = value;
    if (value < 0) {
      throw ArgumentError('Invalid height: $value');
    }
  }

  double y = 0;
}
