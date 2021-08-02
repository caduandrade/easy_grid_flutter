import 'dart:math' as math;
import 'dart:ui';

import 'package:easy_grid/src/axis_behavior.dart';
import 'package:easy_grid/src/configurations.dart';
import 'package:easy_grid/src/easy_grid_layout.dart';
import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class EasyGridRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, EasyGridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, EasyGridParentData> {
  EasyGridRenderBox(
      {required this.horizontalBehavior, required this.verticalBehavior});

  final AxisBehavior horizontalBehavior;
  final AxisBehavior verticalBehavior;

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! EasyGridParentData)
      child.parentData = EasyGridParentData();
  }

  @override
  void performLayout() {
    DateTime start = DateTime.now();

    final BoxConstraints constraints = this.constraints;

    EasyGridLayout layout = _buildLayout();

    layout.iterate((row, column, child) {
      final EasyGridParentData parentData = child.easyGridParentData();
      ChildConfiguration configuration = parentData.configuration!;
      if (parentData.hasSize == false) {
        BoxConstraints c = BoxConstraints.loose(Size.infinite);
        //  c= BoxConstraints.loose(Size(500,500));
        //child.layout(constraints, parentUsesSize: true);
        child.layout(c, parentUsesSize: true);
        parentData.hasSize = true;
      }
      //TODO handle spans
      layout.updateMaxWidth(column: column, width: child.size.width);
      layout.updateMaxHeight(row: row, height: child.size.height);
    });

    layout.updateColumnXs();
    layout.updateRowYs();

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
    if (this.horizontalBehavior == AxisBehavior.fitted) {
      width = constraints.maxWidth;
    } else {
      layout.forEachWidth((value) {
        width += value;
      });
      if (this.horizontalBehavior == AxisBehavior.constrained) {
        width = math.min(constraints.maxWidth, width);
      }
    }
    double height = 0;
    if (this.verticalBehavior == AxisBehavior.fitted) {
      height = constraints.maxHeight;
    } else {
      layout.forEachHeight((value) {
        height += value;
      });
      if (this.verticalBehavior == AxisBehavior.constrained) {
        height = math.min(constraints.maxHeight, height);
      }
    }
    size = Size(width, height);

    DateTime e = DateTime.now();
    print('time: ' + e.difference(start).inMilliseconds.toString());
  }

  EasyGridLayout _buildLayout() {
    EasyGridLayout layout = EasyGridLayout();

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
        layout.addChild(
            child: child,
            row: configuration.row!,
            column: configuration.column!);
      } else {
        layout.addChild(child: child, row: row, column: column);
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
