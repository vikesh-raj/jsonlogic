import 'package:jsonlogic/src/errors.dart';
import 'package:test/test.dart';

void main() {
  test('check to string', () {
    var exp = JsonlogicException('Got Error');
    expect(exp.toString(), 'JsonlogicException: Got Error');
  });
}
