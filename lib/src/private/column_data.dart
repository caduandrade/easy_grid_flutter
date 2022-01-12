import 'dart:collection';
import 'dart:math' as math;

import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:easy_grid/src/grid_column.dart';

class ColumnData {
  ColumnData({required this.index, required this.column});

  final int index;
  final GridColumn column;
  final List<EasyGridParentData> parentsData = [];
  final HashSet<int> indices =HashSet<int>();

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

  double minX = 0;
  double maxX = 0;
}
