import 'package:easy_grid/src/grid_column.dart';
import 'package:easy_grid/src/grid_row.dart';
import 'package:easy_grid/src/private/configurations.dart';
import 'package:easy_grid/src/private/easy_grid_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_case.dart';

class TestCase1 extends TestCase {
  @override
  List<ChildConfiguration> buildChildConfigurations() {
    return [
      ChildConfiguration(
          spanX: 1,
          spanY: 1,
          wrap: false,
          growX: false,
          growY: false,
          skip: 0,
          alignment: Alignment.center,
          minWidth: 0,
          prefWidth: null,
          maxWidth: double.infinity,
          minHeight: 0,
          maxHeight: double.infinity)
    ];
  }

  @override
  List<GridColumn>? buildColumns() {
    return null;
  }

  @override
  List<GridRow>? buildRows() {
    return null;
  }

  @override
  double getChildMaxIntrinsicWidth(
      int childIndex, ChildConfiguration configuration, double maxHeight) {
    return 50;
  }

  @override
  double getChildMinIntrinsicWidth(
      int childIndex, ChildConfiguration configuration, double maxHeight) {
    return 50;
  }

  @override
  Size layoutChild(
      ChildConfiguration configuration, BoxConstraints constraints) {
    print(constraints);
    return Size(50, 50);
  }
}

void main() {
  group('1', () {
    test('Loose', () {
      TestCase1 testCase = TestCase1();
      EasyGridLayout layout = testCase.buildLayout();
      Size size = layout.perform(BoxConstraints.loose(Size(500, 500)));
      expectSize(actualSize: size, expectedWidth: 50, expectedHeight: 50);
    });
    test('tightFor equal', () {
      TestCase1 testCase = TestCase1();
      EasyGridLayout layout = testCase.buildLayout();
      Size size =
          layout.perform(BoxConstraints.tightFor(width: 50, height: 50));
      print(size);
      expectSize(actualSize: size, expectedWidth: 50, expectedHeight: 50);
    });
    test('tightFor smaller', () {
      TestCase1 testCase = TestCase1();
      EasyGridLayout layout = testCase.buildLayout();
      Size size = layout.perform(BoxConstraints.tightFor(width: 5, height: 5));
      print(size);
      expectSize(actualSize: size, expectedWidth: 5, expectedHeight: 5);
    });
    test('Expand', () {
      TestCase1 testCase = TestCase1();
      EasyGridLayout layout = testCase.buildLayout();
      Size size = layout.perform(BoxConstraints.expand());
      print(size);
      expectSize(actualSize: size, expectedWidth: 50, expectedHeight: 50);
    });
    test('Expand Height - Fixed Width', () {
      TestCase1 testCase = TestCase1();
      EasyGridLayout layout = testCase.buildLayout();
      Size size = layout.perform(BoxConstraints.expand(width: 500));
      print(size);
      expectSize(actualSize: size, expectedWidth: 500, expectedHeight: 50);
    });
  });
}
