import 'dart:math' as math;

import 'package:easy_grid/easy_grid.dart';
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
  
  static EasyGridLayout build(List<RenderBox> children, List<GridColumn>? widgetColumns, List<GridRow>? widgetRows){
    _LayoutBuilder builder = _LayoutBuilder();
    return builder.build(children, widgetColumns, widgetRows);
  }

  EasyGridLayout._(Map<_ChildKey, RenderBox> children,List<_Row> rows,List<_Column> columns): this._children=children,this._rows=rows,this._columns=columns;
  
  Map<_ChildKey, RenderBox> _children;

  List<_Row> _rows;
  List<_Column> _columns;  
  
  double totalWidth(){
    double total =0;
    _columns.forEach((element) { 
      total+=element.width;
    });
    return total;
  }

  double totalHeight(){
    double total =0;
    _rows.forEach((element) {
      total+=element.height;
    });
    return total;
  }

  double? columnX({required int column}){
    return _columns[column].x;
  }

  double? rowY({required int row}){
    return _rows[row].y;
  }

  void updateColumnsX() {
    double x = 0;
    _columns.forEach((element) { 
      element.x = x;
      x+=element.width;
    });
  }

  void updateRowsY() {
    double y = 0;
    _rows.forEach((element) { 
      element.y=y;
      y+=element.height;
    });
  }

  void forEachChild(Function(RenderBox child) f) {
    _children.values.forEach(f);
  }

  void iterate(LayoutIterator iterator) {
    for (int row = 0; row < _rows.length; row++) {
      for (int column = 0; column < _columns.length; column++) {
        _ChildKey key = _ChildKey(row: row, column: column);
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

class _Row  {

  _Row({ this.alignment=AxisAlignment.center});

  final AxisAlignment alignment;

  double height =0;
  double y =0;
}

class _Column  {

  _Column({ this.alignment=AxisAlignment.center});

  final AxisAlignment alignment;
  
  double width =0;
  double x =0;
  
}


class _LayoutBuilder {

    EasyGridLayout build(List<RenderBox> children, List<GridColumn>? widgetColumns, List<GridRow>? widgetRows) {
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

    List<_Row> _rows = [];
    if(widgetRows!=null){
      widgetRows.forEach((row) {
        _rows.add(_Row(alignment: row.alignment));
      });
    }
    for(int row =_rows.length; row<=_maxRow ;row++) {
      _rows.add(_Row());
    }

    List<_Column> _columns =[];
    if(widgetColumns!=null){
      widgetColumns.forEach((column) {
        _columns.add(_Column(alignment: column.alignment));
      });
    }
    for(int column =_columns.length; column<=_maxColumn ;column++) {
      _columns.add(_Column());
    }

    return EasyGridLayout._(_children, _rows, _columns);
  }

  Map<_ChildKey, RenderBox> _children = Map<_ChildKey, RenderBox>();
  int _maxRow = 0;
  int _maxColumn = 0;

  void _addChild(
      {required RenderBox child, required int row, required int column}) {
    final EasyGridParentData parentData = child.easyGridParentData();
    if (parentData.configuration == null) {
      throw StateError('Null constraints');
    }

    ChildConfiguration configuration = parentData.configuration!;

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


}