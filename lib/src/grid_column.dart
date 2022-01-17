import 'package:easy_grid/src/axis_alignment.dart';

class GridColumn {
  const GridColumn(
      {this.alignment = AxisAlignment.center, this.fill = 0});

  final AxisAlignment alignment;
  final double fill;
}
