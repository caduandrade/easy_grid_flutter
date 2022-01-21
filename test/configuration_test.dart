import 'package:easy_grid/src/private/configurations.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChildConfiguration', () {
    test('Default', () {
      ChildConfiguration config = ChildConfiguration();
      expect(config.row, null);
      expect(config.column, null);
      expect(config.spanX, 1);
      expect(config.spanY, 1);
      expect(config.growX, false);
      expect(config.growY, false);
      expect(config.skip, 0);
      expect(config.wrap, false);
      expect(config.alignment, Alignment.center);
      expect(config.minWidth, 0);
      expect(config.prefWidth, null);
      expect(config.minHeight, 0);
      expect(config.prefHeight, null);
    });
    test('pref width /pref height', () {
      ChildConfiguration config =
          ChildConfiguration(prefWidth: 50, prefHeight: 100);
      expect(config.prefWidth, 50);
      expect(config.prefHeight, 100);
    });
    test('row / column', () {
      ChildConfiguration config = ChildConfiguration(row: 1, column: 2);
      expect(config.row, 1);
      expect(config.column, 2);
    });
    test('wrap with column', () {
      expect(() => ChildConfiguration(column: 1, wrap: true),
          throwsA(isA<ArgumentError>()));
    });
    test('wrap with row', () {
      expect(() => ChildConfiguration(row: 1, wrap: true),
          throwsA(isA<ArgumentError>()));
    });
    test('set row without column', () {
      expect(() => ChildConfiguration(row: 1), throwsA(isA<ArgumentError>()));
    });
    test('set column without row', () {
      expect(
          () => ChildConfiguration(column: 2), throwsA(isA<ArgumentError>()));
    });
    test('row must be positive', () {
      expect(() => ChildConfiguration(row: -1), throwsA(isA<ArgumentError>()));
    });
    test('column must be positive', () {
      expect(
          () => ChildConfiguration(column: -1), throwsA(isA<ArgumentError>()));
    });
    test('spanX must be bigger than 1', () {
      expect(() => ChildConfiguration(spanX: 0), throwsA(isA<ArgumentError>()));
    });
    test('spanY must be bigger than 1', () {
      expect(() => ChildConfiguration(spanY: 0), throwsA(isA<ArgumentError>()));
    });
    test('skip must be positive', () {
      expect(() => ChildConfiguration(skip: -1), throwsA(isA<ArgumentError>()));
    });
    test('minWidth can not be negativeInfinity', () {
      expect(() => ChildConfiguration(minWidth: double.negativeInfinity),
          throwsA(isA<ArgumentError>()));
    });
    test('minWidth can not be infinity', () {
      expect(() => ChildConfiguration(minWidth: double.infinity),
          throwsA(isA<ArgumentError>()));
    });
    test('minHeight can not be negativeInfinity', () {
      expect(() => ChildConfiguration(minHeight: double.negativeInfinity),
          throwsA(isA<ArgumentError>()));
    });
    test('minHeight can not be infinity', () {
      expect(() => ChildConfiguration(minHeight: double.infinity),
          throwsA(isA<ArgumentError>()));
    });
  });
}
