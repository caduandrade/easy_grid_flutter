class ChildAddress {
  ChildAddress({required this.row, required this.column}) {
    if (this.row < 0) {
      throw ArgumentError('Row must be positive: ${this.row}');
    }
    if (this.column < 0) {
      throw ArgumentError('Column must be positive: ${this.column}');
    }
  }

  final int row;
  final int column;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildAddress &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          column == other.column;

  @override
  int get hashCode => row.hashCode ^ column.hashCode;

  @override
  String toString() {
    return 'ChildAddress{row: $row, column: $column}';
  }
}
