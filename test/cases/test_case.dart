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

void expectOffset({required double expectedX,required double expectedY,required Offset actualOffset}) {
  expect(actualOffset.dx, expectedX, reason: 'X');
  expect(actualOffset.dy, expectedY,reason: 'Y');
}

abstract class TestCase  {

  final List<ChildConfiguration> configurations;
  final List<GridColumn>? columns;
  final List<GridRow>? rows;

  TestCase({required this.configurations, this.columns, this.rows});


  double getChildMaxIntrinsicWidth(int childIndex, ChildConfiguration configuration, double maxHeight);
  double getChildMinIntrinsicWidth(int childIndex, ChildConfiguration configuration, double maxHeight);
  Size layoutChild(ChildConfiguration configuration, BoxConstraints constraints);


  EasyGridLayout buildLayout(){
    List<EasyGridParentData> parentsData = [];
    for(ChildConfiguration configuration in configurations){
      EasyGridParentData parentData = EasyGridParentData();
      parentData.configuration=configuration;
      parentsData.add(parentData);
    }
    return EasyGridLayout(delegate: _LayoutDelegate(this,parentsData), parentsData: parentsData, columns: columns, rows: rows);
  }

}

class _LayoutDelegate with EasyGridLayoutDelegate {

  _LayoutDelegate(this.testCase, this.parentsData);

final TestCase testCase;
final List<EasyGridParentData> parentsData;

  @override
  double getChildMaxIntrinsicWidth(int index, double maxHeight) {
    EasyGridParentData parentData = parentsData[index];
    return testCase.getChildMaxIntrinsicWidth(index, parentData.configuration!, maxHeight);
  }

  @override
  double getChildMinIntrinsicWidth(int index, double maxHeight) {
    EasyGridParentData parentData = parentsData[index];
    return testCase.getChildMinIntrinsicWidth(index, parentData.configuration!, maxHeight);
  }

  @override
  Size layoutChild(int index, BoxConstraints constraints) {
    EasyGridParentData parentData = parentsData[index];
    return testCase.layoutChild(parentData.configuration!,constraints);
  }

}

