import 'package:jsonlogic/jsonlogic.dart';
import 'testcase.dart';
import 'package:test/test.dart';

void dataAccessTests(Jsonlogic jl) {
  var cases = <TestCase>[
    TestCase('string', r'{"var": ["a", "abc"]}',
        '{"a": {"a1":[12, "ax"], "a2":34}}', {
      'a1': [12, 'ax'],
      'a2': 34,
    }),
    TestCase('default', r'{"var": ["a", 1]}', null, 1),
    TestCase('number', r'{"var": [2, "abc"]}',
        r'[{"a": {"a1":[12, "ax"], "a2":34}, "b": 2}, 2, 3]', 3),
    TestCase('combined', r'{"var": ["0.a.a1.1", "abc"]}',
        r'[{"a": {"a1":[12, "ax"], "a2":34}, "b": 2}, 2, 3]', 'ax'),
    TestCase('default', r'{"var": [3, "abc"]}',
        r'[{"a": {"a1":[12, "ax"], "a2":34}, "b": 2}, 2, 3]', 'abc'),
    TestCase('combined default', r'{"var": ["0.a.a1.2", "abc"]}',
        r'[{"a": {"a1":[12, "ax"], "a2":34}, "b": 2}, 2, 3]', 'abc'),
    TestCase(
        'var a',
        r'{"var" : "champ.name"}',
        r'{"champ":{"name":"Fezzig","height":223},"challenger":{"name":"Dread Pirate Roberts","height" : 183}}',
        'Fezzig'),
    TestCase('var 1', r'{"var":1}', r'["zero", "one", "two"]', 'one'),
    TestCase('var empty', r'{ "cat" : ["Hello, ",{"var":""}] }', '"Dolly"',
        'Hello, Dolly'),
    TestCase('var empty list', r'{"var":""}', '[1,2]', [1, 2]),
    TestCase('missing', r'{"missing":["a", "b"]}',
        '{"a":"apple", "c":"carrot"}', ['b']),
    TestCase('missing none', r'{"missing":["a", "b"]}',
        r'{"a":"apple", "b":"banana"}', []),
    TestCase(
        'missing if',
        r'{"if":[{"missing":["a", "b"]},"Not enough fruit","OK to proceed"]}',
        r'{"a":"apple", "b":"banana"}',
        'OK to proceed'),
    TestCase('missing some none', r'{"missing_some":[1, ["a", "b", "c"]]}',
        r'{"a":"apple"}', []),
    TestCase('missing some', r'{"missing_some":[2, ["a", "b", "c"]]}',
        r'{"a":"apple"}', ['b', 'c']),
  ];
  runTestcases(jl, cases, runMode: false);
}

void main() {
  var jl = Jsonlogic();
  test('data access cases', () => dataAccessTests(jl));
}
