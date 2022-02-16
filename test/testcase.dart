import 'package:jsonlogic/jsonlogic.dart';
import 'dart:convert';
import 'package:test/test.dart';

class TestCase {
  String name;
  String rule;
  String? data;
  dynamic expected;
  bool run;
  bool fail;

  TestCase(this.name, this.rule, this.data, this.expected,
      {this.run = false, this.fail = false});
}

void runTestcases(Jsonlogic jl, List<TestCase> cases, {bool runMode = false}) {
  for (var testcase in cases) {
    if (runMode && !testcase.run) {
      continue;
    }
    var rule = json.decode(testcase.rule);
    dynamic data;
    if (testcase.data?.isNotEmpty == true) data = json.decode(testcase.data!);
    var expected = testcase.expected;
    if (testcase.fail) {
      expect(() => jl.apply(rule, data), throwsA(isA<JsonlogicException>()),
          reason: 'Case ${testcase.name}, expected exception');
    } else {
      var output = jl.apply(rule, data);
      expect(output, expected,
          reason: 'Case ${testcase.name}, expected $expected, got $output');
    }
  }
}
