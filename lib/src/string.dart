import 'interface.dart';
import 'dart:convert';

String toString(dynamic v) {
  if (v == null) {
    return '';
  } else if (v is String) {
    return v;
  } else if (v is List || v is Map) {
    return json.encode(v);
  }
  return '$v';
}

dynamic catOperator(Applier applier, dynamic data, List params) {
  var l = params.map((p) {
    var v = applier(p, data);
    return toString(v);
  });
  return l.join();
}
