import 'dart:math' as math;
import 'dart:ui';

import 'package:easy_grid/src/private/configurations.dart';
import 'package:easy_grid/src/private/easy_grid_layout.dart';
import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:easy_grid/src/grid_column.dart';
import 'package:easy_grid/src/grid_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class EasyGridRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, EasyGridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, EasyGridParentData> {
  EasyGridRenderBox({this.columns, this.rows});

  final List<GridColumn>? columns;
  final List<GridRow>? rows;

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
    EasyGridLayout layout = EasyGridLayout.fromRenderBox(
        children: children, columns: this.columns, rows: this.rows);

    layout.iterate((row, column, child) {
      final EasyGridParentData parentData = child.easyGridParentData();
      ChildConfiguration configuration = parentData.configuration!;
      //if (parentData.hasSize == false) {
      // BoxConstraints c = BoxConstraints.loose(Size.infinite);
      //  c= BoxConstraints.loose(Size(500,500));

      child.layout(constraints, parentUsesSize: true);
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
