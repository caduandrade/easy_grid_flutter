import 'dart:math' as math;

import 'package:easy_grid/src/configurations.dart';
import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Utility extension to facilitate obtaining parent data.
extension _EasyGridParentDataGetter on RenderObject {
  EasyGridParentData easyGridParentData() {
    return this.parentData as EasyGridParentData;
  }
}

typedef LayoutIterator = Function(int row, int column, RenderBox child);

class EasyGridLayout {
  Map<_ChildKey, RenderBox> _children = Map<_ChildKey, RenderBox>();

  Map<int, double> _columnX = Map<int, double>();
  Map<int, double> _rowY = Map<int, double>();

  Map<int, double> _maxWidth = Map<int, double>();
  Map<int, double> _maxHeight = Map<int, double>();

  int _maxRow = 0;
  int _maxColumn = 0;

  int get maxRow => _maxRow;
  int get maxColumn => _maxColumn;

  void forEachWidth(Function(double value) f){
    _maxWidth.values.forEach(f);
  }

  void forEachHeight(Function(double value) f){
    _maxHeight.values.forEach(f);
  }

  double? columnX({required int column}){
    return _columnX[column];
  }

  double? rowY({required int row}){
    return _rowY[row];
  }

  void updateColumnXs() {
    double x = 0;
    for (int column = 0; column <= _maxColumn; column++) {
      double? v = width(column: column);
      if (v != null) {
        _columnX[column] = x;
        x += v;
      }
    }
  }

  void updateRowYs() {
    double y = 0;
    for (int row = 0; row <= _maxRow; row++) {
      double? v = height(row: row);
      if (v != null) {
        _rowY[row] = y;
        y += v;
      }
    }
  }

  void forEachChild(Function(RenderBox child) f) {
    _children.values.forEach(f);
  }

  void iterate(LayoutIterator iterator) {
    for (int row = 0; row <= _maxRow; row++) {
      for (int column = 0; column <= _maxColumn; column++) {
        _ChildKey key = _ChildKey(row: row, column: column);
        RenderBox? child = _children[key];
        if (child != null) {
          iterator(row, column, child);
        }
      }
    }
  }

  double? width({required int column}) {
    return _maxWidth[column];
  }

  double? height({required int row}) {
    return _maxHeight[row];
  }

  void updateMaxHeight({required int row, required double height}) {
    if (_maxHeight.containsKey(row)) {
      double max = math.max(_maxHeight[row]!, height);
      _maxHeight[row] = max;
    } else {
      _maxHeight[row] = height;
    }
  }

  void updateMaxWidth({required int column, required double width}) {
    if (_maxWidth.containsKey(column)) {
      double max = math.max(_maxWidth[column]!, width);
      _maxWidth[column] = max;
    } else {
      _maxWidth[column] = width;
    }
  }

  void addChild(
      {required RenderBox child, required int row, required int column}) {
    final EasyGridParentData parentData = child.easyGridParentData();
    if (parentData.configuration == null) {
      throw StateError('Null constraints');
    }

    EasyGridConfiguration configuration = parentData.configuration!;

    for (int r = row; r < row + configuration.spanX; r++) {
      for (int c = column; c < column + configuration.spanY; c++) {
        _ChildKey key = _ChildKey(row: r, column: c);
        if (_children.containsKey(key)) {
          //TODO error collision
        }
        _maxRow = math.max(_maxRow, r);
        _maxColumn = math.max(_maxColumn, c);
        _children[key] = child;
      }
    }

    parentData.initialRow = row;
    parentData.finalRow = row + configuration.spanX - 1;
    parentData.initialColumn = column;
    parentData.finalColumn = column + configuration.spanY - 1;
  }

  RenderBox? getChild({required int row, required int column}) {
    _ChildKey key = _ChildKey(row: row, column: column);
    return _children[key];
  }
}

class _ChildKey {
  const _ChildKey({required this.row, required this.column});

  final int row;
  final int column;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ChildKey &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          column == other.column;

  @override
  int get hashCode => row.hashCode ^ column.hashCode;
}
