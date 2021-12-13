import 'package:easy_grid/src/axis_alignment.dart';
import 'package:easy_grid/src/private/configurations.dart';
import 'package:easy_grid/src/private/layout_column.dart';
import 'package:easy_grid/src/private/layout_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChildConfiguration', () {
    test('OK', () {
      ChildConfiguration config = ChildConfiguration(
          spanX: 1,
          spanY: 2,
          growX: false,
          growY: true,
          skip: 0,
          wrap: false,
          alignment: Alignment.center);
      expect(config.row, null);
      expect(config.column, null);
      expect(config.spanX, 1);
      expect(config.spanY, 2);
      expect(config.growX, false);
      expect(config.growY, true);
      expect(config.skip, 0);
      expect(config.wrap, false);
      expect(config.alignment, Alignment.center);
    });
    test('row / column', () {
      ChildConfiguration config = ChildConfiguration(
          row: 1,
          column: 2,
          spanX: 1,
          spanY: 2,
          growX: false,
          growY: true,
          skip: 0,
          wrap: false,
          alignment: Alignment.center);
      expect(config.row, 1);
      expect(config.column, 2);
    });
    test('no column', () {
      expect(
          () => ChildConfiguration(
              row: 1,
              spanX: 1,
              spanY: 2,
              growX: false,
              growY: true,
              skip: 0,
              wrap: false,
              alignment: Alignment.center),
          throwsA(isA<ArgumentError>()));
    });
    test('no row', () {
      expect(
          () => ChildConfiguration(
              column: 2,
              spanX: 1,
              spanY: 2,
              growX: false,
              growY: true,
              skip: 0,
              wrap: false,
              alignment: Alignment.center),
          throwsA(isA<ArgumentError>()));
    });
    test('row must be positive', () {
      expect(
          () => ChildConfiguration(
              row: -1,
              spanX: 1,
              spanY: 2,
              growX: false,
              growY: true,
              skip: 0,
              wrap: false,
              alignment: Alignment.center),
          throwsA(isA<ArgumentError>()));
    });
    test('column must be positive', () {
      expect(
          () => ChildConfiguration(
              column: -1,
              spanX: 1,
              spanY: 2,
              growX: false,
              growY: true,
              skip: 0,
              wrap: false,
              alignment: Alignment.center),
          throwsA(isA<ArgumentError>()));
    });
    test('spanX must be bigger than 1', () {
      expect(
          () => ChildConfiguration(
              spanX: 0,
              spanY: 2,
              growX: false,
              growY: true,
              skip: 0,
              wrap: false,
              alignment: Alignment.center),
          throwsA(isA<ArgumentError>()));
    });
    test('spanY must be bigger than 1', () {
      expect(
          () => ChildConfiguration(
              spanX: 1,
              spanY: 0,
              growX: false,
              growY: true,
              skip: 0,
              wrap: false,
              alignment: Alignment.center),
          throwsA(isA<ArgumentError>()));
    });
    test('skip must be positive', () {
      expect(
          () => ChildConfiguration(
              spanX: 1,
              spanY: 2,
              growX: false,
              growY: true,
              skip: -1,
              wrap: false,
              alignment: Alignment.center),
          throwsA(isA<ArgumentError>()));
    });
  });
}
