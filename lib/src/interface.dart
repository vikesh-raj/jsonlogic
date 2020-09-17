typedef Applier = dynamic Function(dynamic rule, dynamic data);
typedef Operator = dynamic Function(Applier applier, dynamic data, List params);
