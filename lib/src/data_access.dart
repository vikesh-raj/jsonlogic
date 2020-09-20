import 'interface.dart';
import 'logic.dart';

List findVar(dynamic key, dynamic data) {
  var notFound = false;
  var keyList = <String>[];
  if (key is String) {
    if (key.isEmpty) {
      return [data, false];
    }
    keyList = key.split('.');
  } else if (key is num) {
    keyList = ['$key'];
  } else if (key == null) {
    return [data, false];
  } else {
    notFound = true;
  }
  var d = data;
  for (var key in keyList) {
    if (notFound) break;
    if (d is Map) {
      var value = d[key];
      if (value == null) {
        notFound = true;
      } else {
        d = value;
      }
    } else if (d is List) {
      try {
        var index = int.parse(key);
        if (index < 0 || index >= d.length) {
          notFound = true;
        } else {
          d = d[index];
        }
      } on FormatException {
        notFound = true;
      }
    } else {
      notFound = true;
    }
  }
  return [d, notFound];
}

dynamic varOperator(Applier applier, dynamic data, List params) {
  if (params.isEmpty) return data;

  var key = applier(params[0], data);
  var l = findVar(key, data);
  var d = l[0];
  var notFound = l[1];
  if (notFound) {
    if (params.length >= 2) {
      d = applier(params[1], data);
    } else {
      d = null;
    }
  }
  return d;
}

dynamic varStrictEqualOperator(Applier applier, dynamic data, List params) {
  if (params.length < 2) return null;
  var result = varOperator(applier, data, params);
  return strictEqualOperator(applier, data, [result, params[1]]);
}

dynamic missingOperator(Applier applier, dynamic data, List params) {
  if (params.length == 1) {
    var v = applier(params[0], data);
    if (v is List) {
      params = v;
    } else {
      var l = findVar(v, data);
      if (l[1]) {
        return [v];
      }
      return [];
    }
  }

  var missing = [];
  for (var p in params) {
    var key = applier(p, data);
    var l = findVar(key, data);
    if (l[1]) {
      missing.add(key);
    }
  }
  return missing;
}

dynamic missingSomeOperator(Applier applier, dynamic data, List params) {
  if (params.length != 2) {
    return [];
  }
  var count = applier(params[0], data);
  var list = applier(params[1], data);
  if (count is num && list is List) {
    var minRequired = count.toInt();
    if (minRequired < 1) return [];
    var missing = [];
    var found = 0;
    for (var p in list) {
      var key = applier(p, data);
      var l = findVar(key, data);
      if (l[1]) {
        missing.add(key);
      } else {
        found++;
        if (found >= minRequired) {
          return [];
        }
      }
    }
    return missing;
  }
  return [];
}
