import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:easy_grid/src/grid_column.dart';
import 'package:easy_grid/src/grid_row.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class Case {
  List<GridColumn>? columns();
  List<GridRow>? rows();
  List<EasyGridParentData> parentsData();
  double getMinIntrinsicWidth({required int index, required double maxHeight});
  double getMaxIntrinsicWidth({required int index, required double maxHeight});
}

void defaultTest({required double maxWidth, required double maxHeight}){

//  expect(actual, matcher)
}
