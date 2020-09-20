import 'package:jsonlogic/jsonlogic.dart';
import 'testcase.dart';
import 'package:test/test.dart';

void arrayTests(Jsonlogic jl) {
  var cases = <TestCase>[
    TestCase('map', r'{"map":[{"var":"integers"},{"*":[{"var":""},2]}]}',
        r'{"integers":[1,2,3,4,5]}', [2, 4, 6, 8, 10]),
    TestCase(
        'map2',
        r'{"map": [{"var": "desserts"}, {"var": "qty"}]}',
        r'{"desserts": [{"name": "apple", "qty": 1}, {"name": "brownie", "qty": 2}, {"name": "cupcake", "qty": 3}]}',
        [1, 2, 3]),
    TestCase('filter', r'{"filter":[{"var":"integers"},{"%":[{"var":""},2]}]}',
        r'{"integers":[1,2,3,4,5]}', [1, 3, 5]),
    TestCase(
        'filter 2',
        r'{"filter":[{"var":"integers"},{"%":[{"var":""},2]}]}',
        r'{"integers":[1,2,3,4,5]}',
        [1, 3, 5]),
    TestCase('filter no-op', r'{"filter": [{"var": "integers"}, true]}',
        r'{"integers":[1,2,3]}', [1, 2, 3]),
    TestCase('all', r'{"all":[[1,2,3],{">":[{"var":""},0]} ]}', null, true),
    TestCase('some', r'{"some":[[-1,0,1],{">":[{"var":""},0]}]}', null, true),
    TestCase('none', r'{"none":[[-3,-2,-1],{">":[{"var":""},0]}]}', null, true),
    TestCase(
        'some2',
        r'{"some" : [ {"var":"pies"}, {"==":[{"var":"filling"}, "apple"]} ]}',
        r'{"pies":[{"filling":"pumpkin","temp":110},{"filling":"rhubarb","temp":210},{"filling":"apple","temp":310}]}',
        true),
    TestCase('all empty', r'{"all":[[],{">":[{"var":""},0]}]}', null, false),
    TestCase('some empty', r'{"some":[[],{">":[{"var":""},0]}]}', null, false),
    TestCase('none empty', r'{"none":[[],{">":[{"var":""},0]}]}', null, true),
    TestCase(
        'all false', r'{"all":[[2,-1],{">":[{"var":""},0]}]}', null, false),
    TestCase(
        'some false', r'{"all":[[-2,-1],{">":[{"var":""},0]}]}', null, false),
    TestCase(
        'none false', r'{"all":[[-2,1],{">":[{"var":""},0]}]}', null, false),
    TestCase('merge', r'{"merge":[ [1,2], [3,4] ]}', null, [1, 2, 3, 4]),
    TestCase('merge 2', r'{"merge":[ 1, 2, [3,4] ]}', null, [1, 2, 3, 4]),
    TestCase(
        'merge 3',
        r'{"missing":{"merge":["vin",{"if":[{"var":"financing"},["apr", "term"], []]}]}}',
        r'{"financing":true}',
        ["vin", "apr", "term"]),
    TestCase(
        'merge 3',
        r'{"missing":{"merge":["vin",{"if":[{"var":"financing"},["apr", "term"], []]}]}}',
        r'{"financing":false}',
        ["vin"]),
    TestCase('in list',
        r'{"in":[ "Ringo", ["John", "Paul", "George", "Ringo"] ]}', null, true),
    TestCase('in string', r'{"in":["Spring", "Springfield"]}', null, true),
  ];
  runTestcases(jl, cases, runMode: false);
}

void main() {
  var jl = Jsonlogic();
  test('logic cases', () => arrayTests(jl));
}
