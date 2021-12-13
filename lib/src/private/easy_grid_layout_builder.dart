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

  int _maxRow = 0;
  int _maxColumn = 0;

  EasyGridLayout build(
      {required List<RenderBox> children,
      required List<GridColumn>? columns,
      required List<GridRow>? rows}) {
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

    if (rows != null) {
      rows.forEach((row) {
        _rows.add(LayoutRow(alignment: row.alignment));
      });
    }
    for (int row = _rows.length; row <= _maxRow; row++) {
      _rows.add(LayoutRow());
    }

    if (columns != null) {
      columns.forEach((column) {
        _columns.add(LayoutColumn(alignment: column.alignment));
      });
    }
    for (int column = _columns.length; column <= _maxColumn; column++) {
      _columns.add(LayoutColumn());
    }

    return EasyGridLayout(children: _children, rows: _rows, columns: _columns);
  }

  void _addChild(
      {required RenderBox child, required int row, required int column}) {
    final EasyGridParentData parentData = child.easyGridParentData();
    if (parentData.configuration == null) {
      throw StateError('No parentData configuration');
    }

    ChildConfiguration configuration = parentData.configuration!;

    for (int r = row; r < row + configuration.spanX; r++) {
      for (int c = column; c < column + configuration.spanY; c++) {
        ChildAddress key = ChildAddress(row: r, column: c);
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
}

/// Utility extension to facilitate obtaining parent data.
extension _EasyGridParentDataGetter on RenderObject {
  EasyGridParentData easyGridParentData() {
    return this.parentData as EasyGridParentData;
  }
}
