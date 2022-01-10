import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:easy_grid/src/private/configurations.dart';
import 'package:easy_grid/src/private/easy_grid_layout.dart';
import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:easy_grid/src/grid_column.dart';
import 'package:easy_grid/src/grid_row.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class EasyGridRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, EasyGridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, EasyGridParentData> {
  EasyGridRenderBox({List<GridColumn>? columns, List<GridRow>? rows})
      : this._columns = columns,
        this._rows = rows;

  List<GridColumn>? _columns;
  set columns(List<GridColumn>? columns) {
    if (!listEquals(_columns, columns)) {
      _columns = columns;
      markNeedsLayout();
    }
  }

  List<GridRow>? _rows;
  set rows(List<GridRow>? rows) {
    if (!listEquals(_rows, rows)) {
      _rows = rows;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! EasyGridParentData)
      child.parentData = EasyGridParentData();
  }

  @override
  void performLayout() {
    DateTime start = DateTime.now();

    final BoxConstraints constraints = this.constraints;
    print('constraints: $constraints');

    EasyGridLayout layout =
        EasyGridLayout(firstChild: firstChild, columns: _columns, rows: _rows);

    layout.iterate((row, column, child) {
      // verificar o peso de cada coluna
      // calcular primeiro size de cada um dado max w = max w do cosntraint

      // distribuir width entre colunas com grow e pesos  (grow e peso 0?) - como descobrir max w de peso 0?
      //

      final EasyGridParentData parentData = child.easyGridParentData();
      ChildConfiguration configuration = parentData.configuration!;
      //if (parentData.hasSize == false) {
      // BoxConstraints c = BoxConstraints.loose(Size.infinite);
      //  c= BoxConstraints.loose(Size(500,500));
      BoxConstraints constraints2 = constraints;
      if (column == 991) {
        double minh = child.getMinIntrinsicWidth(constraints.maxHeight);
        double maxh = child.getMaxIntrinsicWidth(constraints.maxHeight);
        constraints2 = BoxConstraints(
            minWidth: minh,
            maxWidth: maxh,
            maxHeight: this.constraints.maxHeight);
      }
      child.layout(constraints2, parentUsesSize: true);
      //  child.layout(c, parentUsesSize: true);
      parentData.hasSize = true;
      //  }
      //TODO handle spans
      layout.updateMaxWidth(column: column, width: child.size.width);
      layout.updateMaxHeight(row: row, height: child.size.height);
    });

    layout.updateColumnsX();
    layout.updateRowsY();

    // updating the offset...
    layout.forEachChild((child) {
      final EasyGridParentData parentData = child.easyGridParentData();
      ChildConfiguration configuration = parentData.configuration!;

      //TODO handle spans
      double x = layout.columnX(column: parentData.initialColumn!)!;
      double y = layout.rowY(row: parentData.initialRow!)!;

      parentData.offset = Offset(x, y);
    });

    // updating the size...
    double width = 0;
    if (constraints.hasInfiniteWidth) {
      width = layout.totalWidth();
    } else {
      width = math.min(constraints.maxWidth, layout.totalWidth());
    }
    double height = 0;
    if (constraints.hasInfiniteHeight) {
      height = layout.totalHeight();
    } else {
      height = math.min(constraints.maxHeight, layout.totalHeight());
    }
    size = Size(width, height);
    print('size: $size');

    DateTime e = DateTime.now();
    print('time: ' + e.difference(start).inMilliseconds.toString());
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

/// Utility extension to facilitate obtaining parent data.
extension _EasyGridParentDataGetter on RenderObject {
  EasyGridParentData easyGridParentData() {
    return this.parentData as EasyGridParentData;
  }
}
