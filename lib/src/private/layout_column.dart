import 'package:easy_grid/src/axis_alignment.dart';

class LayoutColumn {
  LayoutColumn({this.alignment = AxisAlignment.center});

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
