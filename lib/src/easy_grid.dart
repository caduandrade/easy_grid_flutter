import 'package:easy_grid/src/grid_child.dart';
import 'package:easy_grid/src/easy_grid_render_box.dart';
import 'package:easy_grid/src/grid_column.dart';
import 'package:easy_grid/src/grid_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class EasyGrid extends StatelessWidget {
  final List<GridChild> children;
  final List<GridColumn>? columns;
  final List<GridRow>? rows;

  const EasyGrid({Key? key, this.columns, this.rows, required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          child: EasyGrid2(children: children, columns: columns, rows: rows,externalConstraints: constraints));
    });
  }
}

class EasyGrid2 extends MultiChildRenderObjectWidget {
  EasyGrid2({required List<GridChild> children, this.columns, this.rows, required this.externalConstraints})
      : super(children: children);

  final List<GridColumn>? columns;
  final List<GridRow>? rows;
  final BoxConstraints externalConstraints;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return EasyGridRenderBox(columns: columns, rows: rows,externalConstraints:externalConstraints);
  }

  @override
  void updateRenderObject(
      BuildContext context, EasyGridRenderBox renderObject) {
    renderObject
      ..columns = columns
      ..rows = rows
    ..externalConstraints=externalConstraints;
  }
}

class _EasyGridElement extends MultiChildRenderObjectElement {
  _EasyGridElement(EasyGrid2 widget) : super(widget);
}
