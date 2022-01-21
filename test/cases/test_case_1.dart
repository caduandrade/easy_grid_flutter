import 'package:easy_grid/src/private/configurations.dart';
import 'package:easy_grid/src/private/easy_grid_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_case.dart';

class TestCase1 extends TestCase {
  TestCase1()
      : super(configurations: [
          ChildConfiguration(
              minWidth: 0,
              prefWidth: null,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: double.infinity)
        ]);

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
    return Size(50, 50);
  }
}

void main() {
  group('1', () {
    TestCase1 testCase = TestCase1();
    test('Loose', () {
      EasyGridLayout layout = testCase.buildLayout();
      Size size = layout.perform(BoxConstraints.loose(Size(500, 500)));
      expectSize(actualSize: size, expectedWidth: 50, expectedHeight: 50);
    });
    test('tightFor equal', () {
      EasyGridLayout layout = testCase.buildLayout();
      Size size =
          layout.perform(BoxConstraints.tightFor(width: 50, height: 50));
      print(size);
      expectSize(actualSize: size, expectedWidth: 50, expectedHeight: 50);
      childTest(layout);
    });
    test('tightFor smaller', () {
      EasyGridLayout layout = testCase.buildLayout();
      Size size = layout.perform(BoxConstraints.tightFor(width: 5, height: 5));
      print(size);
      expectSize(actualSize: size, expectedWidth: 5, expectedHeight: 5);
      childTest(layout);
    });
    test('Expand', () {
      EasyGridLayout layout = testCase.buildLayout();
      Size size = layout.perform(BoxConstraints.expand());
      print(size);
      expectSize(actualSize: size, expectedWidth: 50, expectedHeight: 50);
      childTest(layout);
    });
    test('Expand Height - Fixed Width', () {
      EasyGridLayout layout = testCase.buildLayout();
      Size size = layout.perform(BoxConstraints.expand(width: 500));
      print(size);
      expectSize(actualSize: size, expectedWidth: 500, expectedHeight: 50);
      childTest(layout);
    });
  });
}

void childTest(EasyGridLayout layout) {
  Size size = layout.getChildSize(0);
  expectSize(actualSize: size, expectedWidth: 50, expectedHeight: 50);
  Offset offset = layout.getChildOffset(0);
  expectOffset(expectedX: 0, expectedY: 0, actualOffset: offset);
}
