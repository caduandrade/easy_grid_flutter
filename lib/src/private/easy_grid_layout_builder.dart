import 'dart:math' as math;
import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:easy_grid/src/grid_column.dart';
import 'package:easy_grid/src/grid_row.dart';
import 'package:easy_grid/src/private/child_address.dart';
import 'package:easy_grid/src/private/configurations.dart';
import 'package:easy_grid/src/private/easy_grid_layout.dart';
import 'package:easy_grid/src/private/layout_column.dart';
import 'package:easy_grid/src/private/layout_row.dart';
import 'package:flutter/rendering.dart';

class EasyGridLayoutBuilder {
  final Map<ChildAddress, RenderBox> _children = Map<ChildAddress, RenderBox>();
  final List<LayoutRow> _rows = [];
  final List<LayoutColumn> _columns = [];

  EasyGridLayout build(
      {required RenderBox? firstChild,
      required List<GridColumn>? columns,
      required List<GridRow>? rows}) {
    if (rows != null) {
      rows.forEach((row) {
        _rows.add(LayoutRow(row));
      });
    }
    if (columns != null) {
      columns.forEach((column) {
        _columns.add(LayoutColumn(column));
      });
    }

    List<RenderBox> children = [];
    RenderBox? child = firstChild;
    while (child != null) {
      final EasyGridParentData parentData = child.easyGridParentData();
      if (parentData.configuration == null) {
        throw StateError('Null constraints');
      }
      parentData.clear();
      children.add(child);
      child = parentData.nextSibling;
    }

    int column = 0;
    int row = 0;
    children.forEach((child) {
      final EasyGridParentData parentData = child.easyGridParentData();
      ChildConfiguration configuration = parentData.configuration!;
      if (configuration.row != null && configuration.column != null) {
        _addChild(
            child: child,
            row: configuration.row!,
            column: configuration.column!);
      } else {
        _addChild(child: child, row: row, column: column);
        if (configuration.wrap) {
          row++;
          column = 0;
        } else {
          column++;
        }
      }
    });

    return EasyGridLayout(children: _children, rows: _rows, columns: _columns);
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
}

/// Utility extension to facilitate obtaining parent data.
extension _EasyGridParentDataGetter on RenderObject {
  EasyGridParentData easyGridParentData() {
    return this.parentData as EasyGridParentData;
  }
}
