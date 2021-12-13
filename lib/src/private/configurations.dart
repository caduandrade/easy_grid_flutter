import 'package:flutter/widgets.dart';

class ChildConfiguration {
  ChildConfiguration(
      {this.row,
      this.column,
      required this.spanX,
      required this.spanY,
      required this.wrap,
      required this.growX,
      required this.growY,
      required this.skip,
      required this.alignment}) {
    if (this.row != null && this.column == null) {
      throw ArgumentError('When the row is defined, the column must also be.');
    }
    if (this.column != null && this.row == null) {
      throw ArgumentError('When the column is defined, the row must also be.');
    }
    if (this.column != null && this.row != null) {
      if (this.skip > 0) {
        throw ArgumentError('skip cannot be used with row and column set.');
      }
      if (this.wrap) {
        throw ArgumentError('wrap cannot be used with row and column set.');
      }
    }
    if (this.row != null && this.row! < 0) {
      throw ArgumentError('row must be positive.');
    }
    if (this.column != null && this.column! < 0) {
      throw ArgumentError('column must be positive.');
    }
    if (this.spanX < 1) {
      throw ArgumentError('spanX must be bigger than 1.');
    }
    if (this.spanY < 1) {
      throw ArgumentError('spanY must be bigger than 1.');
    }
    if (this.skip < 0) {
      throw ArgumentError('skip must be positive.');
    }
  }

  final int? row;
  final int? column;
  final int spanX;
  final int spanY;
  final bool wrap;
  final bool growX;
  final bool growY;
  final int skip;
  final Alignment alignment;
}
