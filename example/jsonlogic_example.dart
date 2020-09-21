import 'package:jsonlogic/jsonlogic.dart';

void main() {
  example1();
}

void example1() {
  var jl = Jsonlogic();
  var rule = {
    "and": [
      {
        "<": [
          {"var": "temp"},
          110
        ]
      },
      {
        "==": [
          {"var": "pie.filling"},
          "apple"
        ]
      }
    ]
  };
  var data = {
    "temp": 100,
    "pie": {"filling": "apple"}
  };
  var answer = jl.apply(rule, data);
  print('example1 answer = $answer');
}
