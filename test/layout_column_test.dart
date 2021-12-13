import 'package:easy_grid/src/axis_alignment.dart';
import 'package:easy_grid/src/private/layout_column.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LayoutColumn', () {
    test('OK', () {
      LayoutColumn column = LayoutColumn();

      expect(column.alignment, AxisAlignment.center);

      expect(column.width, 0);
      column.width = 1;
      expect(column.width, 1);

      expect(column.x, 0);
      column.x = 1;
      expect(column.x, 1);
      column.x = -1;
      expect(column.x, -1);
    });
    test('Error', () {
      LayoutColumn column = LayoutColumn();
      expect(() => column.width = -1, throwsA(isA<ArgumentError>()));
    });
  });
}
