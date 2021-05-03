import 'interface.dart';

num? getNumber(dynamic arg) {
  if (arg is num) {
    return arg;
  } else if (arg is String) {
    try {
      return double.parse(arg);
    } on FormatException {
      return null;
    }
  }
  return null;
}

dynamic binaryOperate(dynamic Function(num n1, num n2) op, Applier applier,
    dynamic data, List params) {
  if (params.length <= 1) {
    return null;
  }

  var v1 = applier(params[0], data);
  var v2 = applier(params[1], data);

  var n1 = getNumber(v1);
  var n2 = getNumber(v2);
  if (n1 == null || n2 == null) {
    return null;
  }
  return op(n1, n2);
}

dynamic reduceOperate(num Function(num n1, num n2) op, Applier applier,
    dynamic data, List params, num zero) {
  var r = zero;
  for (var p in params) {
    var v = applier(p, data);
    var n = getNumber(v);
    if (n == null) {
      return null;
    }
    r = op(r, n);
    if (r.isNaN) {
      break;
    }
  }
  return r;
}

dynamic addOperator(Applier applier, dynamic data, List params) {
  return reduceOperate((a, b) => a + b, applier, data, params, 0.0);
}

dynamic mulOperator(Applier applier, dynamic data, List params) {
  return reduceOperate((a, b) => a * b, applier, data, params, 1.0);
}

dynamic subOperator(Applier applier, dynamic data, List params) {
  if (params.length == 1) {
    var v = applier(params[0], data);
    var n = getNumber(v);
    if (n == null) {
      return null;
    }
    return -n;
  }
  return binaryOperate((a, b) => a - b, applier, data, params);
}

dynamic divOperator(Applier applier, dynamic data, List params) {
  return binaryOperate((a, b) => a / b, applier, data, params);
}

dynamic modOperator(Applier applier, dynamic data, List params) {
  return binaryOperate((a, b) => a % b, applier, data, params);
}

dynamic greaterOperator(Applier applier, dynamic data, List params) {
  var r = reduceOperate(
      (a, b) => a > b ? b : double.nan, applier, data, params, double.infinity);
  if (r == null) return false;
  return !r.isNaN;
}

dynamic greaterEqualOperator(Applier applier, dynamic data, List params) {
  var r = reduceOperate((a, b) => a >= b ? b : double.nan, applier, data,
      params, double.infinity);
  if (r == null) return false;
  return !r.isNaN;
}

dynamic lessOperator(Applier applier, dynamic data, List params) {
  var r = reduceOperate((a, b) => a < b ? b : double.nan, applier, data, params,
      -double.infinity);
  if (r == null) return false;
  return !r.isNaN;
}

dynamic lessEqualOperator(Applier applier, dynamic data, List params) {
  var r = reduceOperate((a, b) => a <= b ? b : double.nan, applier, data,
      params, -double.infinity);
  if (r == null) return false;
  return !r.isNaN;
}

dynamic maxOperator(Applier applier, dynamic data, List params) {
  return reduceOperate(
      (a, b) => a > b ? a : b, applier, data, params, -double.infinity);
}

dynamic minOperator(Applier applier, dynamic data, List params) {
  return reduceOperate(
      (a, b) => a < b ? a : b, applier, data, params, double.infinity);
}
