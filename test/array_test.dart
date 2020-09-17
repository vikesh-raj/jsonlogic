import 'package:jsonlogic/jsonlogic.dart';
import 'testcase.dart';
import 'package:test/test.dart';

void arrayTests(Jsonlogic jl) {
  var cases = <TestCase>[
    TestCase('map', r'{"map":[{"var":"integers"},{"*":[{"var":""},2]}]}',
        r'{"integers":[1,2,3,4,5]}', [2, 4, 6, 8, 10]),
    TestCase('filter', r'{"filter":[{"var":"integers"},{"%":[{"var":""},2]}]}',
        r'{"integers":[1,2,3,4,5]}', [1, 3, 5]),
    TestCase('filter', r'{"filter":[{"var":"integers"},{"%":[{"var":""},2]}]}',
        r'{"integers":[1,2,3,4,5]}', [1, 3, 5]),
  ];
  runTestcases(jl, cases, runMode: false);
}

void main() {
  var jl = Jsonlogic();
  test('logic cases', () => arrayTests(jl));
}
