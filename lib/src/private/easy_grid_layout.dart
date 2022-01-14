import 'dart:collection';
import 'dart:developer';
import 'dart:math' as math;
import 'package:logging/logging.dart';
import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:easy_grid/src/grid_column.dart';
import 'package:easy_grid/src/grid_row.dart';
import 'package:easy_grid/src/private/configurations.dart';
import 'package:easy_grid/src/private/column_data.dart';
import 'package:easy_grid/src/private/row_data.dart';
import 'package:flutter/widgets.dart';

class EasyGridLayout {
  EasyGridLayout._(this.parentsData);

  factory EasyGridLayout(
      {required List<EasyGridParentData> parentsData,
      required List<GridColumn>? columns,
      required List<GridRow>? rows}) {
    EasyGridLayout layout = EasyGridLayout._(parentsData);

    if (rows != null) {
      rows.forEach((row) {
        layout._rows.add(RowData(row: row));
      });
    }
    if (columns != null) {
      columns.forEach((column) {
        layout._columns.add(ColumnData(index: layout._columns.length, column: column));
      });
    }

    int column = 0;
    int row = 0;
    HashSet<_ChildAddress> addresses = HashSet<_ChildAddress>();
    for (int index =0; index<parentsData.length;index++) {
      EasyGridParentData parentData =parentsData[index];
      parentData.clear();

      parentData.index=index;

      ChildConfiguration configuration = parentData.configuration!;
      if (configuration.row != null && configuration.column != null) {
        layout._addChild(addresses:addresses,
            parentData: parentData,
            row: configuration.row!,
            column: configuration.column!);
      } else {
        layout._addChild(addresses:addresses,parentData: parentData, row: row, column: column);
        if (configuration.wrap) {
          row++;
          column = 0;
        } else {
          column+=configuration.spanX;
        }
      }
    }

    return layout;
  }

  final List<RowData> _rows = [];
  final List<ColumnData> _columns = [];
  final List<EasyGridParentData> parentsData;



  void updateX2({required EasyGridParentData parentData}) {
    double lastMaxX = 0;
    double? diff;
    if(parentData.initialColumn! > 0) {
      lastMaxX = _columns[parentData.initialColumn!-1].maxX;
    }
    for(int columnIndex = parentData.initialColumn! ; columnIndex<_columns.length; columnIndex++) {
      ColumnData columnData = _columns[columnIndex];

      columnData.minX=lastMaxX;
      if(diff==null) {
        double newMaxX = lastMaxX + parentData.size!.width;
        diff = newMaxX - columnData.maxX;
      }
      if(diff>0) {
        columnData.maxX+=diff;
      }
      lastMaxX=columnData.maxX;
    }
  }



  void _addChild(
      {required EasyGridParentData parentData,
      required HashSet<_ChildAddress> addresses,
      required int row,
      required int column}) {
    if (parentData.configuration == null) {
      throw StateError('No parentData configuration');
    }

    ChildConfiguration configuration = parentData.configuration!;

    for (int r = row; r < row + configuration.spanY; r++) {
      _row(r).parentsData.add(parentData);
      for (int c = column; c < column + configuration.spanX; c++) {
        _column(c).parentsData.add(parentData);
        _column(c).indices.add(parentData.index!);

        if (addresses.add(_ChildAddress(row: r, column: c)) == false) {
          throw StateError('Collision in column $c and row $r');
        }
      }
    }

    parentData.initialRow = row;
    parentData.finalRow = row + configuration.spanY - 1;
    parentData.initialColumn = column;
    parentData.finalColumn = column + configuration.spanX - 1;
  }

  RowData _row(int row) {
    if (row >= _rows.length) {
      for (int i = _rows.length; i <= row; i++) {
        _rows.add(RowData(row: GridRow()));
      }
    }
    return _rows[row];
  }

  ColumnData _column(int column) {
    if (column >= _columns.length) {
      for (int i = _columns.length; i <= column; i++) {
        _columns.add(ColumnData(index: _columns.length, column: GridColumn()));
      }
    }
    return _columns[column];
  }

  void calculateMaxWidths(){
    _columns.forEach((column)=> column.calculateMaxWidth());
  }

  double totalWidth() {
    if(_columns.isNotEmpty) {
      return _columns.last.maxX;
    }
    return 0;
  }

  double get maxX {
    if(_columns.isNotEmpty) {
      return _columns.last.maxX;
    }
    return 0;
  }

  double totalHeight() {
    double total = 0;
    _rows.forEach((element) {
      total += element.maxHeight;
    });
    return total;
  }

  double? columnMaxX({required int column}) {
    return _columns[column].maxX;
  }

  double? columnMinX({required int column}) {
    return _columns[column].minX;
  }

  double? rowY({required int row}) {
    return _rows[row].y;
  }  



  void updateRowsY() {
    double y = 0;
    _rows.forEach((row) {
      row.y = y;
      y += row.maxHeight;
    });
  }
  

  double? width({required int column}) {
    return _columns[column].maxWidth;
  }

  double? height({required int row}) {
    return _rows[row].maxHeight;
  }

  void updateX({required int childIndex, required Size size}) {
    double lastMaxX = 0;
    double? diff;
    for(ColumnData columnData in _columns) {
      columnData.minX=lastMaxX;
      if(diff==null && columnData.indices.contains(childIndex)) {
        double newMaxX = lastMaxX + size.width;
        diff = newMaxX - columnData.maxX;
      }
      if(diff!=null && diff>0) {
        columnData.maxX+=diff;
      }
      lastMaxX=columnData.maxX;
    }
  }

  void updateX3({required EasyGridParentData parentData}) {
    double lastMaxX = 0;
    double? diff;
    if(parentData.initialColumn! > 0) {
      lastMaxX = _columns[parentData.initialColumn!-1].maxX;
    }
    for(int columnIndex = parentData.finalColumn! ; columnIndex<_columns.length; columnIndex++) {
      ColumnData columnData = _columns[columnIndex];

      columnData.minX=lastMaxX;
      if(diff==null) {
        double newMaxX = lastMaxX + parentData.size!.width;
        diff = newMaxX - columnData.maxX;
      }
      if(diff>0) {
        if(columnData.indices.isEmpty) {
          diff=lastMaxX-columnData.maxX;
          if(diff<=0) {
            return;
          }
        }
        columnData.maxX += diff;
      }
      lastMaxX=columnData.maxX;
    }
  }

  void updateX4({required EasyGridParentData parentData}) {
    double diff=0;
    ColumnData initialColumnData = _columns[parentData.initialColumn!];
    if(parentData.initialColumn!-1 >=0) {
      initialColumnData.minX=_columns[parentData.initialColumn!-1].maxX;
    } else {
      initialColumnData.minX=0;
    }

    ColumnData finalColumnData = _columns[parentData.finalColumn!];
    double newMaxX = initialColumnData.minX + parentData.size!.width;
    diff = newMaxX - finalColumnData.maxX;

    if(diff>0) {
      finalColumnData.maxX+=diff;
     // ColumnData lastColumnData= finalColumnData;
      for(int columnIndex = parentData.finalColumn! +1 ; columnIndex<_columns.length; columnIndex++) {
        ColumnData columnData = _columns[columnIndex];
        columnData.minX += diff;
        if(columnData.indices.isEmpty) {
         // diff=lastColumnData.maxX-columnData.maxX;
          diff=columnData.minX-columnData.maxX;
          if(diff<=0) {
            return;
          }
        }
        columnData.maxX += diff;
       // lastColumnData = columnData;
      }
    }



  }

  void fillWidth({required double maxWidth}) {
    if (maxWidth == double.infinity) {
      log('Cannot define fillPriority with maxWidth infinity constrains',
          level: Level.WARNING.value);
      return;
    }

    double fills = 0;
    for (ColumnData columnData in _columns) {
      GridColumn column = columnData.column;
      if (column.fillPriority < 0) {
        throw StateError(
            'Invalid fillPriority value in column: ${column.fillPriority}');
      }
      fills += column.fillPriority;
    }

    if(fills>0) {
      for(int i =0;i<_columns.length;i++) {
        final ColumnData columnData = _columns[i];
        final GridColumn column = columnData.column;
        if(column.fillPriority>0){
        double availableExtra = (maxWidth - maxX)  *     (column.fillPriority / fills);

          if (i == _columns.length - 1) {
            columnData.maxX += availableExtra;
            print('precisa?');
          } else {
            ColumnData lastColumnData =columnData;
            for (int j = i + 1; j < _columns.length; j++) {
              ColumnData nextColumnData = _columns[j];
              double availableInside = nextColumnData.availableInside;
              if(availableInside>0) {
                lastColumnData.maxX += availableInside;
                nextColumnData.minX += availableInside;
              }

              if (availableExtra > 0) {
                lastColumnData.maxX += availableExtra;
                nextColumnData.minX += availableExtra;
                nextColumnData.maxX += availableExtra;
              }
              lastColumnData = nextColumnData;
            }
          }
        }
      }
    }
  }
  
  double _convert(double value) {
    double newValue = value.roundToDouble();
    return newValue;
  }
}

/// Utility extension to facilitate obtaining parent data.
extension _EasyGridParentDataGetter on RenderObject {
  EasyGridParentData easyGridParentData() {
    return this.parentData as EasyGridParentData;
  }
}

class _ChildAddress {
  _ChildAddress({required this.row, required this.column});

  final int row;
  final int column;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ChildAddress &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          column == other.column;

  @override
  int get hashCode => row.hashCode ^ column.hashCode;
}
