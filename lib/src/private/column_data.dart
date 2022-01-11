import 'dart:math' as math;

import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:easy_grid/src/grid_column.dart';

class ColumnData {
  ColumnData({required this.column});

  final GridColumn column;
  final List<EasyGridParentData> parentsData = [];

  double  _maxWidth = 0;
  double get maxWidth => _maxWidth;
  void calculateMaxWidth(){
    double w = 0;
    for (EasyGridParentData parentData in parentsData) {
      if (parentData.size != null) {
        w += math.max(w, parentData.size!.width);
      }
    }
    _maxWidth=w;
  }
  void incMaxWidth(double v) {
    _maxWidth+=v;
  }

  double x = 0;
}
