import 'package:jsonlogic/jsonlogic.dart';
import 'testcase.dart';
import 'package:test/test.dart';

void logicTests(Jsonlogic jl) {
  var d = r'{}';
  var cases = <TestCase>[
    TestCase('true', r'{"if" : [ true, "yes", "no" ]}', d, 'yes'),
    TestCase('false', r'{"if" : [ false, "yes", "no" ]}', d, 'no'),
    TestCase('false 2', r'{"if" : [ false, "yes" ]}', d, null),
    TestCase(
        'elseif',
        r'{"if" : [{"<": [{"var":"temp"}, 0] }, "freezing",{"<": [{"var":"temp"}, 100] }, "liquid","gas"]}',
        '{"temp":55}',
        'liquid'),
    TestCase('1 === 1', r'{"===": [1, 1]}', d, true),
    TestCase('1 === 2', r'{"===": [1, 2]}', d, false),
    TestCase('1 === "1"', r'{"===" : [1, "1"]}', d, false),
    TestCase('"a" !== "a"', r'{"!==": ["a", "a"]}', d, false),
    TestCase('1 !== "1"', r'{"!==": [1, "1"]}', d, true),
    TestCase('![true]', r'{"!": [true]}', d, false),
    TestCase('! true', r'{"!": true}', d, false),
    TestCase('!![[]]', r'{"!!": [[]]}', d, false),
    TestCase('!!["0"]', r'{"!!": ["0"]}', d, true),
    TestCase('or', r'{"or":[false, "1", ""]}', d, '1'),
    TestCase('or', r'{"or":[false, 0, ""]}', d, ''),
    TestCase('and', r'{"and":[true,"a",3]}', d, 3),
    TestCase('and', r'{"and":[true,"",3]}', d, ''),
    TestCase('==', r'{"==" : [1, 1]}', d, true),
    TestCase('==', r'{"==" : [1,[1]]}', d, true),
    TestCase('==', r'{"==" : [[1,2,3],[1,2]]}', d, false),
    TestCase('==', r'{"==" : [[1,2,3],[]]}', d, false),
    TestCase('==', r'{"==" : [[1,2,3],{}]}', d, false),
    TestCase('==', r'{"==" : [[1,2,3],"one"]}', d, false),
    TestCase('==', r'{"==" : [[1,2],["one", "two"]]}', d, false),
    TestCase('== string', r'{"==" : [1, "1"]}', d, true),
    TestCase('== bool', r'{"==" : [0, false]}', d, true),
    TestCase('== bool false', r'{"==" : [0, true]}', d, false),
    TestCase('!=', r'{"!=" : [1, 2]}', d, true),
    TestCase('!= false', r'{"!=" : [1, "1"]}', d, false),
  ];
  runTestcases(jl, cases, runMode: false);
}

void main() {
  var jl = Jsonlogic();
  test('logic cases', () => logicTests(jl));
}
