import 'dart:math' as math;
import 'package:easy_grid/src/easy_grid.dart';
import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:easy_grid/src/private/configurations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class GridChild extends ParentDataWidget<EasyGridParentData> {
  factory GridChild.at(
      {required Widget child,
      required int row,
      required int column,
      int spanX = 1,
      int spanY = 1,
      bool growX = false,
      bool growY = false,
      Alignment alignment = Alignment.center,
      double minWidth = 0,
        double? prefWidth,
      double minHeight = 0,
      double? height}) {
    return GridChild._(
        child: child,
        configuration: ChildConfiguration(
            row: row,
            column: column,
            spanX: spanX,
            spanY: spanY,
            wrap: false,
            growX: growX,
            growY: growY,
            skip: 0,
            alignment: alignment,
            minWidth: minWidth,
            prefWidth: prefWidth,
            minHeight: minHeight,
            prefHeight: height));
  }

  factory GridChild(
      {required Widget child,
      int spanX = 1,
      int spanY = 1,
      bool wrap = false,
      bool growX = false,
      bool growY = false,
      int skip = 0,
      Alignment alignment = Alignment.center,
      double minWidth = 0,
        double? prefWidth,
      double minHeight = 0,
      double? height}) {
    return GridChild._(
        child: child,
        configuration: ChildConfiguration(
            spanX: spanX,
            spanY: spanY,
            wrap: wrap,
            growX: growX,
            growY: growY,
            skip: skip,
            alignment: alignment,
            minWidth: minWidth,
            prefWidth: prefWidth,
            minHeight: minHeight,
            prefHeight: height));
  }

  GridChild._({
    required this.configuration,
    required Widget child,
  }) : super(child: child);

  final ChildConfiguration configuration;

  @override
  void applyParentData(RenderObject renderObject) {
    final EasyGridParentData parentData =
        renderObject.parentData! as EasyGridParentData;
    if (parentData.configuration != configuration) {
      parentData.configuration = configuration;
      final AbstractNode? targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => EasyGrid2;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<Object>('configuration.row', configuration.row));
    properties.add(DiagnosticsProperty<Object>(
        'configuration.column', configuration.column));
    properties.add(
        DiagnosticsProperty<Object>('configuration.wrap', configuration.wrap));
    properties.add(
        DiagnosticsProperty<Object>('configuration.skip', configuration.skip));
    properties.add(DiagnosticsProperty<Object>(
        'configuration.growX', configuration.growX));
    properties.add(DiagnosticsProperty<Object>(
        'configuration.growY', configuration.growY));
    properties.add(DiagnosticsProperty<Object>(
        'configuration.spanX', configuration.spanX));
    properties.add(DiagnosticsProperty<Object>(
        'configuration.spanY', configuration.spanY));
    properties.add(DiagnosticsProperty<Object>(
        'configuration.alignment', configuration.alignment));
    properties.add(DiagnosticsProperty<Object>(
        'configuration.minWidth', configuration.minWidth));
    properties.add(DiagnosticsProperty<Object>(
        'configuration.minHeight', configuration.minHeight));
    properties.add(DiagnosticsProperty<Object>(
        'configuration.height', configuration.prefHeight));
  }
}
