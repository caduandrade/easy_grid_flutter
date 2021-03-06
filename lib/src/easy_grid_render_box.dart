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
        RenderBoxContainerDefaultsMixin<RenderBox, EasyGridParentData>,EasyGridLayoutDelegate {
  EasyGridRenderBox(
      {required List<GridColumn>? columns,
      required List<GridRow>? rows,
      required BoxConstraints externalConstraints})
      : this._columns = columns,
        this._rows = rows,
        this._externalConstraints = externalConstraints;

  BoxConstraints _externalConstraints;
  set externalConstraints(BoxConstraints externalConstraints) {
    if (_externalConstraints != externalConstraints) {
      _externalConstraints = externalConstraints;
      markNeedsLayout();
    }
  }

  List<RenderBox> _children = [];

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
  double getChildMinIntrinsicWidth(int index, double maxHeight) {
    RenderBox child = _children[index];
    return child.getMinIntrinsicWidth(constraints.maxHeight);
  }

  @override
  double getChildMaxIntrinsicWidth(int index, double maxHeight) {
    RenderBox child = _children[index];
    return child.getMaxIntrinsicWidth(constraints.maxHeight);
  }

  @override
  Size layoutChild(int index, BoxConstraints constraints) {
    RenderBox child = _children[index];
    child.layout(constraints, parentUsesSize: true);
    return child.size;
  }

  @override
  void performLayout() {
    DateTime start = DateTime.now();

    List<EasyGridParentData> parentsData = [];

    _children.clear();
    RenderBox? child = firstChild;
    while (child != null) {
      final EasyGridParentData parentData = child.easyGridParentData();
      if (parentData.configuration == null) {
        throw StateError('Null constraints');
      }
      parentsData.add(parentData);
      _children.add(child);
      child = parentData.nextSibling;
    }


    //print('ex $_externalConstraints  c $constraints');

    EasyGridLayout layout = EasyGridLayout(delegate: this,
        parentsData: parentsData, columns: _columns, rows: _rows);


    size = layout.perform(_externalConstraints);
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
