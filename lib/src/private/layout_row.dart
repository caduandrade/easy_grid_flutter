import 'package:easy_grid/src/axis_alignment.dart';

class LayoutRow {
  LayoutRow({this.alignment = AxisAlignment.center});

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
