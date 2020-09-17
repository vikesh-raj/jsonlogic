import 'package:jsonlogic/jsonlogic.dart';
import 'testcase.dart';
import 'package:test/test.dart';

void defaultAggTests(Jsonlogic jl) {
  var cases = <TestCase>[
    TestCase("nil case", 'null', r'[true]', null),
    TestCase("default aggregate true", r'{"===" : [1, 1], "var": 0, "+": [1]}',
        r'[true]', true),
    TestCase("default aggregate false",
        r'{"===" : [1, 1], "var": 0, "+": [1, -1]}', r'[true]', false),
  ];
  runTestcases(jl, cases);
}

void quickVarTests(Jsonlogic jl) {
  var cases = <TestCase>[
    TestCase('quick var match', r'{"$name": "Jack"}', '{"name": "Jack"}', true),
    TestCase(
        '2x quick var match',
        r'{"$name.first": "Jack", "$name.last": "Johnson"}',
        r'{"name": {"first": "Jack", "last": "Johnson"}}',
        true),
    TestCase(
        '2x quick var mismatch',
        r'{"$name.first": "Jack", "$name.last": "Johnson"}',
        r'{"name": {"first": "Johnson", "last": "Johnson"}}',
        false),
  ];
  runTestcases(jl, cases);
}

void errorTests() {
  var jl = Jsonlogic();
  jl.remove('_default_aggregator');
  jl.remove('_quick_access');
  var cases = <TestCase>[
    TestCase('empty op', r'{"": 1}', r'{}', null, fail: true),
    TestCase('not found op', r'{"not_found": 1}', r'{}', null, fail: true),
    TestCase('not aggregator', r'{"+": 1, "-": 1}', r'{}', null, fail: true),
    TestCase('not quick access', r'{"$id": 1}', r'{}', null, fail: true),
  ];
  runTestcases(jl, cases);
}

void main() {
  var jl = Jsonlogic();
  test('default aggregate cases', () => defaultAggTests(jl));
  test('quick var cases', () => quickVarTests(jl));
  test('error cases', errorTests);
}
