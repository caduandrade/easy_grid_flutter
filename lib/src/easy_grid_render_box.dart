import 'dart:math' as math;
import 'package:easy_grid/src/private/configurations.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_grid/src/private/easy_grid_layout.dart';
import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:easy_grid/src/grid_column.dart';
import 'package:easy_grid/src/grid_row.dart';
import 'package:flutter/rendering.dart';

class EasyGridRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, EasyGridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, EasyGridParentData> {
  EasyGridRenderBox({required List<GridColumn>? columns,required List<GridRow>? rows,required BoxConstraints externalConstraints})
      : this._columns = columns,
        this._rows = rows,
  this._externalConstraints=externalConstraints;

  BoxConstraints _externalConstraints;
  set externalConstraints(BoxConstraints externalConstraints){
    if(_externalConstraints!=externalConstraints){
      _externalConstraints=externalConstraints;
      markNeedsLayout();
    }
  }

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

    final BoxConstraints scrollConstraints = this.constraints;

    List<EasyGridParentData> parentsData = [];
    List<RenderBox> children =[];
    RenderBox? child = firstChild;
    while (child != null) {
      final EasyGridParentData parentData = child.easyGridParentData();
      if (parentData.configuration == null) {
        throw StateError('Null constraints');
      }
      parentsData.add(parentData);
      children.add(child);
      child = parentData.nextSibling;
    }

    EasyGridLayout layout =
    EasyGridLayout(parentsData: parentsData, columns: _columns, rows: _rows);

     BoxConstraints constraints2 = BoxConstraints.loose(Size(constraints.maxWidth, constraints.maxHeight));




    for(int index = 0;index<children.length;index++){
      RenderBox child = children[index];

      double minh = child.getMinIntrinsicWidth(constraints.maxHeight);
      double maxh = child.getMaxIntrinsicWidth(constraints.maxHeight);
      print('$minh $maxh');
      constraints2 = BoxConstraints(minWidth: minh,  maxWidth: maxh,      maxHeight: this.constraints.maxHeight);

      child.layout(constraints2, parentUsesSize: true);
      final EasyGridParentData parentData = child.easyGridParentData();
      parentData.size = child.size;
      ChildConfiguration configuration = parentData.configuration!;
      //layout.updateX(childIndex: index, size: child.size);
      layout.updateX4(parentData: parentData);
    }

    layout.fillWidth(maxWidth: _externalConstraints.maxWidth);

/*
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

 */

   // layout.handleAvaiableWidth(maxWidth: _externalConstraints.maxWidth);
    //layout.updateColumnsX();

    layout.updateRowsY();

    for(int index = 0;index<children.length;index++) {
      RenderBox child = children[index];
      final EasyGridParentData parentData = child.easyGridParentData();
      ChildConfiguration configuration = parentData.configuration!;

      //TODO handle spans
      double x = layout.columnMinX(column: parentData.initialColumn!)!;
      double y = layout.rowY(row: parentData.initialRow!)!;

      parentData.offset = Offset(x, y);
    }

    // updating the size...
    double width = 0;
    if (scrollConstraints.hasInfiniteWidth) {
      width = layout.totalWidth();
    } else {
      width = math.min(scrollConstraints.maxWidth, layout.totalWidth());
    }
    double height = 0;
    if (scrollConstraints.hasInfiniteHeight) {
      height = layout.totalHeight();
    } else {
      height = math.min(scrollConstraints.maxHeight, layout.totalHeight());
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
