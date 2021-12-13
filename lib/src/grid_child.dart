import 'dart:math' as math;
import 'package:easy_grid/src/easy_grid.dart';
import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:easy_grid/src/private/configurations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class GridChild extends ParentDataWidget<EasyGridParentData> {
  factory GridChild(
      {required Widget child,
      int? row,
      int? column,
      int spanX = 1,
      int spanY = 1,
      bool wrap = false,
      bool growX = false,
      bool growY = false,
      int skip = 0,
      Alignment alignment = Alignment.center}) {
    return GridChild._(
        child: child,
        configuration: ChildConfiguration(
            row: row,
            column: column,
            spanX: spanX,
            spanY: spanY,
            wrap: wrap,
            growX: growX,
            growY: growY,
            skip: skip,
            alignment: alignment));
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
  Type get debugTypicalAncestorWidgetClass => EasyGrid;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<Object>('configuration.row', configuration.row));
    properties.add(DiagnosticsProperty<Object>(
        'configuration.column', configuration.column));
  }
}
