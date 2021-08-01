import 'dart:math' as math;
import 'dart:ui';

import 'package:easy_grid/src/axis_behavior.dart';
import 'package:easy_grid/src/configurations.dart';
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
    final BoxConstraints constraints = this.constraints;

    Map<int, double> maxWidthMap = Map<int, double>();
    Map<int, double> maxHeightMap = Map<int, double>();

    int currentColumn = 0;
    int currentRow = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final EasyGridParentData parentData = child.easyGridParentData();
      if (parentData.configuration == null) {
        throw StateError('Null constraints');
      }

      EasyGridConfiguration configuration = parentData.configuration!;


      BoxConstraints c = BoxConstraints.loose(Size.infinite);
      //  c= BoxConstraints.loose(Size(500,500));
      //child.layout(constraints, parentUsesSize: true);
      child.layout(c, parentUsesSize: true);

      double maxWidth = 0;
      if (maxWidthMap.containsKey(currentColumn)) {
        maxWidth = maxWidthMap[currentColumn]!;
      }
      maxWidth = math.max(maxWidth, child.size.width);
      maxWidthMap[currentColumn] = maxWidth;

      double maxHeight = 0;
      if (maxHeightMap.containsKey(currentRow)) {
        maxHeight = maxHeightMap[currentRow]!;
      }
      maxHeight = math.max(maxHeight, child.size.height);
      maxHeightMap[currentRow] = maxHeight;

      if (configuration.wrap) {
        currentRow++;
        currentColumn=0;
      } else {
        currentColumn++;
      }
      child = parentData.nextSibling;
    }

    currentColumn = 0;
    currentRow = 0;
    child = firstChild;
    double x = 0;
    double y = 0;
    while (child != null) {
      final EasyGridParentData parentData = child.easyGridParentData();
      EasyGridConfiguration configuration = parentData.configuration!;

      parentData.offset = Offset(x, y);

      if (configuration.wrap) {
        x = 0;
        y += maxHeightMap[currentRow]!;
        currentColumn = 0;
        currentRow++;
      } else {
        x += child.size.width;
        currentColumn++;
      }
      child = parentData.nextSibling;
    }

    double width = 0;
    if (this.horizontalBehavior == AxisBehavior.fitted) {
      width = constraints.maxWidth;
    } else {
      maxWidthMap.values.forEach((value) {
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
      maxHeightMap.values.forEach((value) {
        height += value;
      });
      if (this.verticalBehavior == AxisBehavior.constrained) {
        height = math.min(constraints.maxHeight, height);
      }
    }

    size = Size(width, height);
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
