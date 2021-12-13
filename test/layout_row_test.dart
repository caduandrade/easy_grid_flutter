import 'package:easy_grid/src/axis_alignment.dart';
import 'package:easy_grid/src/private/layout_column.dart';
import 'package:easy_grid/src/private/layout_row.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LayoutRow', () {
    test('OK', () {
      LayoutRow row = LayoutRow();

      expect(row.alignment, AxisAlignment.center);

      expect(row.height, 0);
      row.height = 1;
      expect(row.height, 1);

      expect(row.y, 0);
      row.y = 1;
      expect(row.y, 1);
      row.y = -1;
      expect(row.y, -1);
    });
    test('Error', () {
      LayoutRow row = LayoutRow();
      expect(() => row.height = -1, throwsA(isA<ArgumentError>()));
    });
  });
}
