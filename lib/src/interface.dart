/// Applier applies the rule on the given data.
/// It is the first argument passed to the operator function.
typedef Applier = dynamic Function(dynamic rule, dynamic data);

/// Operator applies the given operator on the list of params.
typedef Operator = dynamic Function(Applier applier, dynamic data, List params);
