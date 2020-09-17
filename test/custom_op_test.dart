import 'package:jsonlogic/jsonlogic.dart';
import 'dart:convert';
import 'package:test/test.dart';

int gcd(int a, int b) {
  if (b == 0) return a;
  return gcd(b, a % b);
}

dynamic gcdOperator(Applier applier, dynamic data, List params) {
  if (params.length != 2) {
    throw JsonlogicException('Only 2 parameters are supported');
  }
  var p0 = applier(params[0], data);
  var p1 = applier(params[1], data);
  if (p0 is num && p1 is num) {
    return gcd(p0.toInt(), p1.toInt());
  }
  throw JsonlogicException('params should be numbers');
}

void main() {
  var jl = Jsonlogic();
  test('custom operator', () {
    jl.add('gcd', gcdOperator);
    var rule = json.decode(r'{"gcd": [{"+": [14, 1]}, 25]}');
    var result = jl.apply(rule, null);
    expect(result, 5);
  });
}
