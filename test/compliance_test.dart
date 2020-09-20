import 'package:jsonlogic/jsonlogic.dart';
import 'package:test/test.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

class TestCase {
  final int id;
  final String name;
  final dynamic rule;
  final dynamic data;
  final dynamic expected;
  TestCase(this.id, this.name, this.rule, this.data, this.expected);
}

List<TestCase> loadTests(String file) {
  final tests = json.decode(File(file).readAsStringSync()) as List;
  var output = <TestCase>[];
  var lastComment = '';
  var i = 0;
  for (var item in tests) {
    if (item is String) {
      lastComment = item;
    } else if (item is List && item.length == 3) {
      var tc = TestCase(i, lastComment, item[0], item[1], item[2]);
      output.add(tc);
    }
    i++;
  }
  return output;
}

void runTestcases(Jsonlogic jl, List<TestCase> cases) {
  for (var testcase in cases) {
    var expected = testcase.expected;
    var output = jl.apply(testcase.rule, testcase.data);
    print('Test ${testcase.id} ${testcase.name}, rule : ${testcase.rule}');
    expect(output, expected,
        reason:
            'Case id : ${testcase.id} ${testcase.name}, input ${testcase.rule} expected $expected, got $output');
  }
}

void main() {
  var jl = Jsonlogic();
  var tests = <TestCase>[];
  if (File('./compliance/tests.json').existsSync()) {
    tests = loadTests('./compliance/tests.json');
  } else if (File('../compliance/tests.json').existsSync()) {
    tests = loadTests('../compliance/tests.json');
  }
  test('compliance cases', () => runTestcases(jl, tests));
}
