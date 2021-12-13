import 'package:easy_grid/src/grid_child.dart';
import 'package:easy_grid/src/easy_grid_render_box.dart';
import 'package:easy_grid/src/grid_column.dart';
import 'package:easy_grid/src/grid_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class EasyGrid extends MultiChildRenderObjectWidget {
  EasyGrid._(
      {required List<GridChild> children,
      required this.columns,
      required this.rows})
      : super(children: children);

  factory EasyGrid(
      {required List<GridChild> children,
      List<GridColumn>? columns,
      List<GridRow>? rows}) {
    //TODO remove factor?

    return EasyGrid._(children: children, columns: columns, rows: rows);
  }

  final List<GridColumn>? columns;
  final List<GridRow>? rows;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return EasyGridRenderBox(columns: columns, rows: rows);
  }
}

class _EasyGridElement extends MultiChildRenderObjectElement {
  _EasyGridElement(EasyGrid widget) : super(widget);
}
