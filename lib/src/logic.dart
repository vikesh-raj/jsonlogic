import 'interface.dart';
import 'truth.dart';
import 'string.dart';

dynamic ifOperator(Applier applier, dynamic data, List params) {
  while (true) {
    if (params.isEmpty) return null;
    if (params.length == 1) {
      return applier(params[0], data);
    }
    var cond = applier(params[0], data);
    if (truth(cond)) {
      return applier(params[1], data);
    } else if (params.length < 2) {
      return null;
    }
    params = params.sublist(2);
  }
}

bool isEqual(Applier applier, dynamic data, List params) {
  if (params.isEmpty) {
    return false;
  }
  if (params.length == 1) {
    return applier(params[0], data) == null;
  }
  var v1 = applier(params[0], data);
  var v2 = applier(params[1], data);
  if (v1 is String || v2 is String) {
    return toString(v1) == toString(v2);
  }
  if (v1 is bool || v2 is bool) {
    return truth(v1) == truth(v2);
  }
  return v1 == v2;
}

dynamic equalOperator(Applier applier, dynamic data, List params) {
  return isEqual(applier, data, params);
}

dynamic notEqualOperator(Applier applier, dynamic data, List params) {
  return !isEqual(applier, data, params);
}

dynamic strictEqualOperator(Applier applier, dynamic data, List params) {
  if (params.isEmpty) {
    return false;
  }
  if (params.length == 1) {
    return applier(params[0], data) == null;
  }
  var v1 = applier(params[0], data);
  var v2 = applier(params[1], data);
  return v1 == v2;
}

dynamic strictNEOperator(Applier applier, dynamic data, List params) {
  if (params.isEmpty) {
    return false;
  }
  if (params.length == 1) {
    return applier(params[0], data) != null;
  }
  var v1 = applier(params[0], data);
  var v2 = applier(params[1], data);
  return v1 != v2;
}

dynamic notOperator(Applier applier, dynamic data, List params) {
  if (params.isEmpty) {
    return false;
  }
  var v = applier(params[0], data);
  return !truth(v);
}

dynamic notNotOperator(Applier applier, dynamic data, List params) {
  if (params.isEmpty) {
    return false;
  }
  var v = applier(params[0], data);
  return truth(v);
}

dynamic orOperator(Applier applier, dynamic data, List params) {
  var v;
  for (var p in params) {
    v = applier(p, data);
    if (truth(v)) return v;
  }
  return v;
}

dynamic andOperator(Applier applier, dynamic data, List params) {
  var v;
  for (var p in params) {
    v = applier(p, data);
    if (!truth(v)) return v;
  }
  return v;
}

dynamic andBoolOperator(Applier applier, dynamic data, List params) {
  var v;
  for (var p in params) {
    v = applier(p, data);
    if (!truth(v)) return false;
  }
  return true;
}
