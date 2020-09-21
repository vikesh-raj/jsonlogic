import 'interface.dart';
import 'truth.dart';

List toList(dynamic arg) {
  if (arg is List) return arg;
  return [arg];
}

dynamic arrayApply(dynamic Function(List args, List applied) f,
    dynamic defaultValue, Applier applier, dynamic data, List params) {
  if (params.length != 2) {
    return defaultValue;
  }
  var d = applier(params[0], data);
  var opdata = params[1];
  if (d is List) {
    if (opdata is Map<String, dynamic> && opdata.length == 1) {
      var op = opdata.keys.first;
      var data = opdata.values.first;
      if (data is List) {
        var args = List.from(d.map((elem) => applier(data[0], elem)));
        var restArgs = data.sublist(1);
        var applied = List.from(args.map((p) => applier({
              op: [p] + restArgs
            }, d)));
        return f(args, applied);
      } else {
        var applied = List.from(d.map((p) => applier(opdata, p)));
        return f(d, applied);
      }
    } else {
      var applied = List.from(d.map((p) => applier(opdata, p)));
      return f(d, applied);
    }
  }
  return defaultValue;
}

dynamic boolArrayApply(
    bool Function(List array) f, Applier applier, dynamic data, List params) {
  return arrayApply((args, applied) => f(applied), null, applier, data, params);
}

dynamic mapOperator(Applier applier, dynamic data, List params) {
  return arrayApply((_, applied) => applied, [], applier, data, params);
}

dynamic filterOperator(Applier applier, dynamic data, List params) {
  List filter(List args, List applied) {
    var output = [];
    for (int i = 0; i < args.length; i++) {
      if (truth(applied[i])) {
        output.add(args[i]);
      }
    }
    return output;
  }

  return arrayApply(filter, [], applier, data, params);
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
  return initialValue;
}

dynamic allOperator(Applier applier, dynamic data, List params) {
  bool all(List array) {
    if (array.isEmpty) return false;
    for (var a in array) {
      if (!truth(a)) return false;
    }
    return true;
  }

  return boolArrayApply(all, applier, data, params);
}

dynamic someOperator(Applier applier, dynamic data, List params) {
  bool some(List array) {
    if (array.isEmpty) return false;
    for (var a in array) {
      if (truth(a)) return true;
    }
    return false;
  }

  return boolArrayApply(some, applier, data, params);
}

dynamic noneOperator(Applier applier, dynamic data, List params) {
  bool none(List array) {
    for (var a in array) {
      if (truth(a)) return false;
    }
    return true;
  }

  return boolArrayApply(none, applier, data, params);
}

dynamic mergeOperator(Applier applier, dynamic data, List params) {
  var output = [];
  for (var p in params) {
    var v = toList(applier(p, data));
    output.addAll(v);
  }
  return output;
}

dynamic inOperator(Applier applier, dynamic data, List params) {
  if (params.length != 2) {
    return false;
  }
  var i = applier(params[0], data);
  var l = applier(params[1], data);
  if (i is String && l is String) {
    return l.contains(i);
  }
  if (i is String && l is List) {
    return l.contains(i);
  }
  return false;
}
