import 'dart:math' as math;
import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:easy_grid/src/grid_row.dart';

class RowData {

  RowData({required this.row});

  final GridRow row;
   final List<EasyGridParentData> parentsData=[];

  double get maxHeight {
    double h = 0;
    for (EasyGridParentData parentData in parentsData) {
      if (parentData.size != null) {
        h += math.max(h, parentData.size!.height);
      }
    }
    return h;
  }

  double y = 0;
}
