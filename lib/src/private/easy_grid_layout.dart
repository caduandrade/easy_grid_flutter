import 'dart:math' as math;

import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:easy_grid/src/grid_column.dart';
import 'package:easy_grid/src/grid_row.dart';
import 'package:easy_grid/src/private/child_address.dart';
import 'package:easy_grid/src/private/configurations.dart';
import 'package:easy_grid/src/private/layout_column.dart';
import 'package:easy_grid/src/private/layout_row.dart';
import 'package:flutter/widgets.dart';

typedef LayoutIterator = Function(int row, int column, RenderBox child);

class EasyGridLayout {
  EasyGridLayout._();

  factory EasyGridLayout(
      {required RenderBox? firstChild,
        required List<GridColumn>? columns,
        required List<GridRow>? rows}) {
    EasyGridLayout layout = EasyGridLayout._();

    if (rows != null) {
      rows.forEach((row) {
        layout._rows.add(LayoutRow(row));
      });
    }
    if (columns != null) {
      columns.forEach((column) {
        layout._columns.add(LayoutColumn(column));
      });
    }

    int column = 0;
    int row = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final EasyGridParentData parentData = child.easyGridParentData();
      if (parentData.configuration == null) {
        throw StateError('Null constraints');
      }
      parentData.clear();

      ChildConfiguration configuration = parentData.configuration!;
      if (configuration.row != null && configuration.column != null) {
        layout._addChild(
            child: child,
            row: configuration.row!,
            column: configuration.column!);
      } else {
        layout._addChild(child: child, row: row, column: column);
        if (configuration.wrap) {
          row++;
          column = 0;
        } else {
          column++;
        }
      }

      child = parentData.nextSibling;
    }

    return layout;
  }

  final Map<ChildAddress, RenderBox> _children= Map<ChildAddress, RenderBox>();
  final List<LayoutRow> _rows=[];
  final List<LayoutColumn> _columns=[];

  void _addChild(
      {required RenderBox child, required int row, required int column}) {
    final EasyGridParentData parentData = child.easyGridParentData();
    if (parentData.configuration == null) {
      throw StateError('No parentData configuration');
    }

    ChildConfiguration configuration = parentData.configuration!;

    for (int r = row; r < row + configuration.spanX; r++) {
      _layoutRow(r).children.add(child);
      for (int c = column; c < column + configuration.spanY; c++) {
        _layoutColumn(c).children.add(child);
        ChildAddress key = ChildAddress(row: r, column: c);
        if (_children.containsKey(key)) {
          throw StateError('Collision in column $c and row $r');
        }
        _children[key] = child;
      }
    }

    parentData.initialRow = row;
    parentData.finalRow = row + configuration.spanX - 1;
    parentData.initialColumn = column;
    parentData.finalColumn = column + configuration.spanY - 1;
  }

  LayoutRow _layoutRow(int row) {
    if (row >= _rows.length) {
      for (int i = _rows.length; i <= row; i++) {
        _rows.add(LayoutRow(GridRow()));
      }
    }
    return _rows[row];
  }

  LayoutColumn _layoutColumn(int column) {
    if (column >= _columns.length) {
      for (int i = _columns.length; i <= column; i++) {
        _columns.add(LayoutColumn(GridColumn()));
      }
    }
    return _columns[column];
  }

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

/// Utility extension to facilitate obtaining parent data.
extension _EasyGridParentDataGetter on RenderObject {
  EasyGridParentData easyGridParentData() {
    return this.parentData as EasyGridParentData;
  }
}
