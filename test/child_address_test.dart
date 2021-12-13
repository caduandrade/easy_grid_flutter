import 'package:easy_grid/src/private/child_address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChildAddress', () {
    test('OK', () {
      ChildAddress childAddress = ChildAddress(row: 0, column: 1);
      expect(childAddress.column, 1);
      expect(childAddress.row, 0);
      childAddress = ChildAddress(row: 1, column: 0);
      expect(childAddress.column, 0);
      expect(childAddress.row, 1);
    });
    test('Row error', () {
      expect(() => ChildAddress(row: -1, column: 0),
          throwsA(isA<ArgumentError>()));
    });
    test('Column error', () {
      expect(() => ChildAddress(row: 0, column: -1),
          throwsA(isA<ArgumentError>()));
    });
  });
}
