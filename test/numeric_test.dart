import 'package:jsonlogic/jsonlogic.dart';
import 'testcase.dart';
import 'package:test/test.dart';

void numericTests(Jsonlogic jl) {
  var d = r'{}';
  var cases = <TestCase>[
    TestCase('+', r'{"+": [6, 2]}', d, 8),
    TestCase('-', r'{"-": [6, 2]}', d, 4),
    TestCase('*', r'{"*": [6, 2]}', d, 12),
    TestCase('/', r'{"/": [6, 2]}', d, 3),
    TestCase('/', r'{"/": [6, 4]}', d, 1.5),
    TestCase('list +', r'{"+": [1, 2, 3, 4, 5]}', d, 15),
    TestCase('list *', r'{"*": [1, 2, 3, 4, 5]}', d, 120),
    TestCase('inv', r'{"-": 2}', d, -2),
    TestCase('inv neg', r'{"-": -2}', d, 2),
    TestCase('to number', r'{"+": 3.14}', d, 3.14),
    TestCase('%', r'{"%": [101, 2]}', d, 1),
    TestCase('>', r'{">": [2, 1, 0, -1]}', d, true),
    TestCase('> error input', r'{">": ["error", 1, 0, -1]}', d, false),
    TestCase('not >', r'{">": [2, 2, 1, 0]}', d, false),
    TestCase('>=', r'{">=": [2, 2, 1, 0]}', d, true),
    TestCase('not >=', r'{">=": [1, 2, 1, 0]}', d, false),
    TestCase('<', r'{"<": [1, 2, 3, 4]}', d, true),
    TestCase('not <', r'{"<": [1, 2, 2, 4]}', d, false),
    TestCase('<=', r'{"<=": [1, 2, 2, 4]}', d, true),
    TestCase('not <=', r'{"<=": [1, 2, 1, 4]}', d, false),
    TestCase('min', r'{"min": [3, 1, 4, 2]}', d, 1),
    TestCase('max', r'{"max": [3, 1, 4, 2]}', d, 4),
  ];
  runTestcases(jl, cases, runMode: false);
}

void main() {
  var jl = Jsonlogic();
  test('numeric cases', () => numericTests(jl));
}
