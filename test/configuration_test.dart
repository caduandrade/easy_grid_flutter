import 'package:easy_grid/src/axis_alignment.dart';
import 'package:easy_grid/src/private/configurations.dart';
import 'package:easy_grid/src/private/column_data.dart';
import 'package:easy_grid/src/private/row_data.dart';
import 'package:flutter/widgets.dart';

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
          alignment: Alignment.center,
          minWidth: 0,
          prefWidth: null,
          maxWidth: double.infinity,
          minHeight: 1,
          maxHeight: 100);
      expect(config.row, null);
      expect(config.column, null);
      expect(config.spanX, 1);
      expect(config.spanY, 2);
      expect(config.growX, false);
      expect(config.growY, true);
      expect(config.skip, 0);
      expect(config.wrap, false);
      expect(config.alignment, Alignment.center);
      expect(config.minWidth, 0);
      expect(config.prefWidth, null);
      expect(config.maxWidth, double.infinity);
      expect(config.width, null);
      expect(config.minHeight, 1);
      expect(config.maxHeight, 100);
      expect(config.height, null);
    });
    test('width / height', () {
      ChildConfiguration config = ChildConfiguration(
          spanX: 1,
          spanY: 1,
          growX: false,
          growY: false,
          skip: 0,
          wrap: false,
          alignment: Alignment.center,
          minWidth: 0,
          prefWidth: null,
          maxWidth: double.infinity,
          width: 50,
          minHeight: 0,
          maxHeight: double.infinity,
          height: 100);
      expect(config.width, 50);
      expect(config.height, 100);
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
          alignment: Alignment.center,
          minWidth: 0,
          prefWidth: null,
          maxWidth: double.infinity,
          minHeight: 0,
          maxHeight: double.infinity);
      expect(config.row, 1);
      expect(config.column, 2);
    });
    test('wrap / row / column', () {
      expect(
          () => ChildConfiguration(
              row: 1,
              column: 2,
              spanX: 1,
              spanY: 2,
              growX: false,
              growY: true,
              skip: 1,
              wrap: false,
              alignment: Alignment.center,
              minWidth: 0,
              prefWidth: null,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: double.infinity),
          throwsA(isA<ArgumentError>()));
    });
    test('wrap / row / column', () {
      expect(
          () => ChildConfiguration(
              row: 1,
              column: 2,
              spanX: 1,
              spanY: 2,
              growX: false,
              growY: true,
              skip: 0,
              wrap: true,
              alignment: Alignment.center,
              minWidth: 0,
              prefWidth: null,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: double.infinity),
          throwsA(isA<ArgumentError>()));
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
              alignment: Alignment.center,
              minWidth: 0,
              prefWidth: null,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: double.infinity),
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
              alignment: Alignment.center,
              minWidth: 0,
              prefWidth: null,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: double.infinity),
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
              alignment: Alignment.center,
              minWidth: 0,
              prefWidth: null,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: double.infinity),
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
              alignment: Alignment.center,
              minWidth: 0,
              prefWidth: null,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: double.infinity),
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
              alignment: Alignment.center,
              minWidth: 0,
              prefWidth: null,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: double.infinity),
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
              alignment: Alignment.center,
              minWidth: 0,
              prefWidth: null,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: double.infinity),
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
              alignment: Alignment.center,
              minWidth: 0,
              prefWidth: null,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: double.infinity),
          throwsA(isA<ArgumentError>()));
    });
    test('minWidth can not be negativeInfinity', () {
      expect(
          () => ChildConfiguration(
              spanX: 1,
              spanY: 2,
              growX: false,
              growY: true,
              skip: 0,
              wrap: false,
              alignment: Alignment.center,
              minWidth: double.negativeInfinity,
              maxWidth: double.infinity,
              minHeight: 0,
              prefWidth: null,
              maxHeight: double.infinity),
          throwsA(isA<ArgumentError>()));
    });
    test('minWidth can not be infinity', () {
      expect(
          () => ChildConfiguration(
              spanX: 1,
              spanY: 2,
              growX: false,
              growY: true,
              skip: 0,
              wrap: false,
              alignment: Alignment.center,
              minWidth: double.infinity,
              maxWidth: double.infinity,
              minHeight: 0,
              prefWidth: null,
              maxHeight: double.infinity),
          throwsA(isA<ArgumentError>()));
    });
    test('maxWidth must be bigger than minWidth', () {
      expect(
          () => ChildConfiguration(
              spanX: 1,
              spanY: 2,
              growX: false,
              growY: true,
              skip: 0,
              wrap: false,
              alignment: Alignment.center,
              minWidth: 10,
              prefWidth: null,
              maxWidth: 2,
              minHeight: 0,
              maxHeight: double.infinity),
          throwsA(isA<ArgumentError>()));
    });
    test('minHeight can not be negativeInfinity', () {
      expect(
          () => ChildConfiguration(
              spanX: 1,
              spanY: 2,
              growX: false,
              growY: true,
              skip: 0,
              wrap: false,
              alignment: Alignment.center,
              minWidth: 0,
              prefWidth: null,
              maxWidth: double.infinity,
              minHeight: double.negativeInfinity,
              maxHeight: double.infinity),
          throwsA(isA<ArgumentError>()));
    });
    test('minHeight can not be infinity', () {
      expect(
          () => ChildConfiguration(
              spanX: 1,
              spanY: 2,
              growX: false,
              growY: true,
              skip: 0,
              wrap: false,
              alignment: Alignment.center,
              minWidth: 0,
              prefWidth: null,
              maxWidth: double.infinity,
              minHeight: double.infinity,
              maxHeight: double.infinity),
          throwsA(isA<ArgumentError>()));
    });
    test('maxHeight must be bigger than minHeight', () {
      expect(
          () => ChildConfiguration(
              spanX: 1,
              spanY: 2,
              growX: false,
              growY: true,
              skip: 0,
              wrap: false,
              alignment: Alignment.center,
              minWidth: 0,
              prefWidth: null,
              maxWidth: double.infinity,
              minHeight: 20,
              maxHeight: 10),
          throwsA(isA<ArgumentError>()));
    });
  });
}
