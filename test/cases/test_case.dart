import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:easy_grid/src/grid_column.dart';
import 'package:easy_grid/src/grid_row.dart';
import 'package:easy_grid/src/private/configurations.dart';
import 'package:easy_grid/src/private/easy_grid_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void expectSize({required double expectedWidth,required double expectedHeight,required Size actualSize}) {
  expect(actualSize.width, expectedWidth, reason: 'Width');
  expect(actualSize.height, expectedHeight,reason: 'Height');
}

abstract class TestCase  {

  late List<EasyGridParentData> parentsData;
  late List<GridColumn>? columns;
  late List<GridRow>? rows;

  List<GridColumn>? buildColumns();
  List<GridRow>? buildRows();
  List<ChildConfiguration> buildChildConfigurations();


  double getChildMaxIntrinsicWidth(int childIndex, ChildConfiguration configuration, double maxHeight);
  double getChildMinIntrinsicWidth(int childIndex, ChildConfiguration configuration, double maxHeight);
  Size layoutChild(ChildConfiguration configuration, BoxConstraints constraints);

  Size getChildSize(int index) {
    return parentsData[index].size!;
  }

  Offset getChildOffset(int index) {
    return parentsData[index].offset;
  }

  EasyGridLayout buildLayout(){
    parentsData = [];
    for(ChildConfiguration configuration in buildChildConfigurations()){
      EasyGridParentData parentData = EasyGridParentData();
      parentData.configuration=configuration;
      parentsData.add(parentData);
    }
    columns = buildColumns();
    rows= buildRows();
    return EasyGridLayout(delegate: _LayoutDelegate(this), parentsData: parentsData, columns: columns, rows: rows);
  }

}

class _LayoutDelegate with EasyGridLayoutDelegate {

  _LayoutDelegate(this.testCase);

final TestCase testCase;


  @override
  double getChildMaxIntrinsicWidth(int index, double maxHeight) {
    EasyGridParentData parentData = testCase.parentsData[index];
    return testCase.getChildMaxIntrinsicWidth(index, parentData.configuration!, maxHeight);
  }

  @override
  double getChildMinIntrinsicWidth(int index, double maxHeight) {
    EasyGridParentData parentData = testCase.parentsData[index];
    return testCase.getChildMinIntrinsicWidth(index, parentData.configuration!, maxHeight);
  }

  @override
  Size layoutChild(int index, BoxConstraints constraints) {
    EasyGridParentData parentData = testCase.parentsData[index];
    return testCase.layoutChild(parentData.configuration!,constraints);
  }

}

