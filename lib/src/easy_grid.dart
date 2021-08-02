import 'package:easy_grid/src/axis_alignment.dart';
import 'package:easy_grid/src/axis_behavior.dart';
import 'package:easy_grid/src/configurations.dart';
import 'package:easy_grid/src/easy_grid_parent_data.dart';
import 'package:easy_grid/src/easy_grid_render_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class EasyGrid extends MultiChildRenderObjectWidget {
  EasyGrid._(
      {required List<GridChild> children,
      required this.horizontalBehavior,
      required this.verticalBehavior,
      required this.columns,
      required this.rows})
      : super(children: children);

  factory EasyGrid(
      {required List<GridChild> children,
      AxisBehavior horizontalBehavior = AxisBehavior.constrained,
      AxisBehavior verticalBehavior = AxisBehavior.constrained,
      List<GridColumn>? columns,
      List<GridRow>? rows}) {


    return EasyGrid._(
        children: children,
        horizontalBehavior: horizontalBehavior,
        verticalBehavior: verticalBehavior,
        columns: columns != null ? columns : [],
        rows: rows != null ? rows : []);
  }

  final AxisBehavior horizontalBehavior;
  final AxisBehavior verticalBehavior;
  final List<GridColumn> columns;
  final List<GridRow> rows;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return EasyGridRenderBox(
        horizontalBehavior: horizontalBehavior,
        verticalBehavior: verticalBehavior);
  }
}

class _EasyGridElement extends MultiChildRenderObjectElement {
  _EasyGridElement(EasyGrid widget) : super(widget);
}

class GridColumn {
  const GridColumn({required this.alignment});

  final AxisAlignment alignment;
}

class GridRow {
  const GridRow({required this.alignment});

  final AxisAlignment alignment;
}

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
    //TODO error wrap and row and column
    //TODO error skip and row and column
    //TODO error row without column
    //TODO error column without row
    return GridChild._(
        child: child,
        configuration: EasyGridConfiguration(
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

  final EasyGridConfiguration configuration;

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
