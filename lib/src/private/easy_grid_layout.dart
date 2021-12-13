import 'dart:math' as math;

import 'package:easy_grid/easy_grid.dart';
import 'package:easy_grid/src/private/child_address.dart';
import 'package:easy_grid/src/private/easy_grid_layout_builder.dart';
import 'package:easy_grid/src/private/layout_column.dart';
import 'package:easy_grid/src/private/layout_row.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef LayoutIterator = Function(int row, int column, RenderBox child);

class EasyGridLayout {
  factory EasyGridLayout.fromRenderBox(
      {required List<RenderBox> children,
      required List<GridColumn>? columns,
      required List<GridRow>? rows}) {
    EasyGridLayoutBuilder builder = EasyGridLayoutBuilder();
    return builder.build(children: children, columns: columns, rows: rows);
  }

  EasyGridLayout(
      {required Map<ChildAddress, RenderBox> children,
      required List<LayoutRow> rows,
      required List<LayoutColumn> columns})
      : this._children = children,
        this._rows = rows,
        this._columns = columns;

  final Map<ChildAddress, RenderBox> _children;
  final List<LayoutRow> _rows;
  final List<LayoutColumn> _columns;

  double totalWidth() {
    double total = 0;
    _columns.forEach((element) {
      total += element.width;
    });
    return total;
  }

  double totalHeight() {
    double total = 0;
    _rows.forEach((element) {
      total += element.height;
    });
    return total;
  }

  double? columnX({required int column}) {
    return _columns[column].x;
  }

  double? rowY({required int row}) {
    return _rows[row].y;
  }

  void updateColumnsX() {
    double x = 0;
    _columns.forEach((element) {
      element.x = x;
      x += element.width;
    });
  }

  void updateRowsY() {
    double y = 0;
    _rows.forEach((element) {
      element.y = y;
      y += element.height;
    });
  }

  void forEachChild(Function(RenderBox child) f) {
    _children.values.forEach(f);
  }

  void iterate(LayoutIterator iterator) {
    for (int row = 0; row < _rows.length; row++) {
      for (int column = 0; column < _columns.length; column++) {
        ChildAddress key = ChildAddress(row: row, column: column);
        RenderBox? child = _children[key];
        if (child != null) {
          iterator(row, column, child);
        }
      }
    }
  }

  double? width({required int column}) {
    return _columns[column].width;
  }

  double? height({required int row}) {
    return _rows[row].height;
  }

  void updateMaxHeight({required int row, required double height}) {
    _rows[row].height = math.max(_rows[row].height, height);
  }

  void updateMaxWidth({required int column, required double width}) {
    _columns[column].width = math.max(_columns[column].width, width);
  }

  RenderBox? getChild({required int row, required int column}) {
    ChildAddress key = ChildAddress(row: row, column: column);
    return _children[key];
  }
}
