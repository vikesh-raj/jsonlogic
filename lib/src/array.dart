import 'interface.dart';
import 'logic.dart';

List toList(dynamic arg) {
  if (arg is List) {
    return arg;
  }
  return [arg];
}

dynamic mapOperator(Applier applier, dynamic data, List params) {
  if (params.length != 2) {
    return [];
  }
  var d = applier(params[0], data);
  var opdata = params[1];
  if (opdata is Map && opdata.length == 1) {
    var op = opdata.keys.first;
    var data = opdata.values.first;
    if (op is String && data is List && data.length > 1) {
      var args = applier(data[0], d);
      if (args != null) {
        var restArgs = data.sublist(1);
        return List.from(toList(args).map((p) => applier({
              op: [p] + restArgs
            }, d)));
      }
    }
  }
  return [];
}

dynamic filterOperator(Applier applier, dynamic data, List params) {
  if (params.length != 2) {
    return [];
  }
  var d = applier(params[0], data);
  var opdata = params[1];
  if (opdata is Map && opdata.length == 1) {
    var op = opdata.keys.first;
    var data = opdata.values.first;
    if (op is String && data is List && data.length > 1) {
      var args = applier(data[0], d);
      if (args != null) {
        var restArgs = data.sublist(1);
        return List.from(toList(args).where((p) => isTrue(applier({
              op: [p] + restArgs
            }, d))));
      }
    }
  }
  return [];
}

dynamic reduce(
    List data, Applier applier, Map<String, dynamic> opdata, dynamic zero) {
  var r = zero;
  for (var d in data) {
    r = applier(opdata, {"current": d, "accumulator": r});
  }
  return r;
}

dynamic reduceOperator(Applier applier, dynamic data, List params) {
  if (params.length != 3) {
    return null;
  }
  var d = applier(params[0], data);
  var opdata = params[1];
  var initialValue = params[2];
  if (d is List && opdata is Map && opdata.length == 1) {
    return reduce(d, applier, opdata, initialValue);
  }
  return null;
}
