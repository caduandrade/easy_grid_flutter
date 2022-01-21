import 'package:flutter/widgets.dart';

class ChildConfiguration {
  ChildConfiguration({this.row,
    this.column,
     this.spanX=1,
     this.spanY=1,
     this.wrap=false,
     this.growX =false,
     this.growY=false,
     this.skip=0,
     this.alignment=Alignment.center,
     this.minWidth=0,
     this.prefWidth,
     this.minHeight=0,
    this.prefHeight}) {
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
    if (this.minWidth == double.negativeInfinity) {
      throw ArgumentError('minWidth can not be negativeInfinity.');
    }
    if (this.minWidth == double.infinity) {
      throw ArgumentError('minWidth can not be infinity.');
    }
    if (this.minHeight == double.negativeInfinity) {
      throw ArgumentError('minHeight can not be negativeInfinity.');
    }
    if (this.minHeight == double.infinity) {
      throw ArgumentError('minHeight can not be infinity.');
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
  final double minWidth;
  final double? prefWidth;
  final double minHeight;
  final double? prefHeight;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildConfiguration &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          column == other.column &&
          spanX == other.spanX &&
          spanY == other.spanY &&
          wrap == other.wrap &&
          growX == other.growX &&
          growY == other.growY &&
          skip == other.skip &&
          alignment == other.alignment &&
          minWidth == other.minWidth &&
          prefWidth == other.prefWidth &&
          minHeight == other.minHeight &&
          prefHeight == other.prefHeight;

  @override
  int get hashCode =>
      row.hashCode ^
      column.hashCode ^
      spanX.hashCode ^
      spanY.hashCode ^
      wrap.hashCode ^
      growX.hashCode ^
      growY.hashCode ^
      skip.hashCode ^
      alignment.hashCode ^
      minWidth.hashCode ^
      prefWidth.hashCode ^
      minHeight.hashCode ^
      prefHeight.hashCode;
}