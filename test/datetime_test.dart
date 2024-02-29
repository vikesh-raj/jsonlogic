import 'package:jsonlogic/jsonlogic.dart';
import 'testcase.dart';
import 'package:test/test.dart';

void datetimeTests(Jsonlogic jl) {
  var cases = <TestCase>[
    // Test cases for date comparisons
    TestCase('date ==', r'{"==": [{"var": "date_str1"}, "2011-12-12T00:00:00"]}', r'{"date_str1":"2011-12-12T00:00:00"}', true),
    TestCase('date !=', r'{"!=": [{"var": "date_str1"}, "2011-12-13T00:00:00"]}', r'{"date_str1":"2011-12-12T00:00:00"}', true),
    TestCase('date <', r'{"<": [{"var": "date_str1"}, "2011-12-13T00:00:00"]}', r'{"date_str1":"2011-12-12T00:00:00"}', true),
    TestCase('date <=', r'{"<=": [{"var": "date_str1"}, "2011-12-12T00:00:00"]}', r'{"date_str1":"2011-12-12T00:00:00"}', true),
    TestCase('date >', r'{">": [{"var": "date_str1"}, "2011-12-11T00:00:00"]}', r'{"date_str1":"2011-12-12T00:00:00"}', true),
    TestCase('date >=', r'{">=": [{"var": "date_str1"}, "2011-12-12T00:00:00"]}', r'{"date_str1":"2011-12-12T00:00:00"}', true),
    TestCase('now compare', r'{"<=": [{"var": "datetime_str1"},{"now": []}]}', r'{"datetime_str1":"2024-02-29T12:30:00"}', true),
    TestCase('current date compare', r'{"!=": [{"var": "date_str1"},{"current_date": []}]}', r'{"date_str1":"2024-02-28T00:00:00"}', true),

    // Test cases for date manipulations
    TestCase('add days', r'{"==": [{"var": "date_str1"}, {"date_add": [{"var": "date_str2"}, 8, "day"]}]}', r'{"date_str1": "2024-01-20T00:00:00", "date_str2": "2024-01-12T00:00:00"}', true),
    TestCase('subtract days', r'{"==": [{"var": "date_str1"}, {"date_add": [{"var": "date_str2"}, -8, "day"]}]}', r'{"date_str1": "2024-01-12T00:00:00", "date_str2": "2024-01-20T00:00:00"}', true),
    TestCase('add months', r'{"==": [{"var": "date_str1"}, {"date_add": [{"var": "date_str2"}, 2, "month"]}]}', r'{"date_str1": "2024-03-12T00:00:00", "date_str2": "2024-01-12T00:00:00"}', true),
    TestCase('subtract months', r'{"==": [{"var": "date_str1"}, {"date_add": [{"var": "date_str2"}, -2, "month"]}]}', r'{"date_str1": "2024-01-12T00:00:00", "date_str2": "2024-03-12T00:00:00"}', true),
    TestCase('add years', r'{"==": [{"var": "date_str1"}, {"date_add": [{"var": "date_str2"}, 3, "year"]}]}', r'{"date_str1": "2027-01-12T00:00:00", "date_str2": "2024-01-12T00:00:00"}', true),
    TestCase('subtract years', r'{"==": [{"var": "date_str1"}, {"date_add": [{"var": "date_str2"}, -3, "year"]}]}', r'{"date_str1": "2024-01-12T00:00:00", "date_str2": "2027-01-12T00:00:00"}', true),
    TestCase('current date add days', r'{"<": [{"var": "date_str1"},{"date_add": [{"current_date": []},5,"day"]}]}', r'{"date_str1": "2024-01-12T00:00:00"}', true),
    TestCase('now add days', r'{"<=": [{"var": "datetime_str1"},{"date_add": [{"now": []},5,"day"]}]}', r'{"datetime_str1": "2024-01-12T12:30:00"}', true),

  ];

  runTestcases(jl, cases, runMode: false);
}

void main() {
  var jl = Jsonlogic();
  test('datetime cases', () => datetimeTests(jl));
}
