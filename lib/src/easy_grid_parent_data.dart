import 'package:easy_grid/src/private/configurations.dart';
import 'package:flutter/rendering.dart';

class EasyGridParentData extends ContainerBoxParentData<RenderBox> {
  ChildConfiguration? configuration;

  int? initialRow;
  int? finalRow;
  int? initialColumn;
  int? finalColumn;
  int? index;
  Size? size;

  void clear() {
    initialRow = null;
    finalRow = null;
    initialColumn = null;
    finalColumn = null;
    index=null;
    size=null;
  }
}
