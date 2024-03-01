import 'datetime.dart';
import 'interface.dart';
import 'errors.dart';
import 'data_access.dart';
import 'logic.dart';
import 'numeric.dart';
import 'string.dart';
import 'array.dart';

const _defaultAggregator = '_default_aggregator';
const _quickVarPrefix = r'$';
const _quickVarOp = '_quick_access';

/// Jsonlogic evaluates the jsonlogic rules for the given data.
class Jsonlogic {
  late Map<String, Operator> _ops;

  /// Creates the Jsonlogic class with default operations.
  Jsonlogic() {
    _ops = <String, Operator>{};
    _addDefaultOps();
  }

  /// Creates the Jsonlogic class with no operations. The operations needs to
  /// manually added via the `add` function.
  Jsonlogic.empty() {
    _ops = <String, Operator>{};
  }

  /// add a function/operator.
  void add(String name, Operator op) {
    _ops[name] = op;
  }

  /// remove a function/operator
  void remove(String name) {
    _ops.remove(name);
  }

  /// applies the give rule with given data.
  dynamic apply(dynamic rule, dynamic data) {
    return _apply(rule, data);
  }

  void _addDefaultOps() {
    _ops['+'] = addOperator;
    _ops['-'] = subOperator;
    _ops['*'] = mulOperator;
    _ops['/'] = divOperator;
    _ops['%'] = modOperator;
    _ops['>'] = greaterOperator;
    _ops['>='] = greaterEqualOperator;
    _ops['<'] = lessOperator;
    _ops['<='] = lessEqualOperator;
    _ops['min'] = minOperator;
    _ops['max'] = maxOperator;
    _ops['var'] = varOperator;
    _ops['missing'] = missingOperator;
    _ops['missing_some'] = missingSomeOperator;
    _ops['if'] = ifOperator;
    _ops['?:'] = ifOperator;
    _ops['=='] = equalOperator;
    _ops['!='] = notEqualOperator;
    _ops['==='] = strictEqualOperator;
    _ops['!=='] = strictNEOperator;
    _ops['!'] = notOperator;
    _ops['!!'] = notNotOperator;
    _ops['or'] = orOperator;
    _ops['and'] = andOperator;
    _ops[_defaultAggregator] = andBoolOperator;
    _ops[_quickVarOp] = varStrictEqualOperator;
    _ops['cat'] = catOperator;
    _ops['map'] = mapOperator;
    _ops['filter'] = filterOperator;
    _ops['reduce'] = reduceOperator;
    _ops['all'] = allOperator;
    _ops['some'] = someOperator;
    _ops['none'] = noneOperator;
    _ops['merge'] = mergeOperator;
    _ops['in'] = inOperator;
    _ops['substr'] = substrOperator;
    _ops['log'] = logOperator;
    _ops['now'] = nowOperator;
    _ops['current_date'] = currentDateOperator;
    _ops['date_add'] = dateAddOperator;
  }

  dynamic _apply(dynamic rule, dynamic data) {
    dynamic result;
    if (rule == null ||
        rule is bool ||
        rule is num ||
        rule is String ||
        rule is List) {
      return rule;
    }
    if (rule is Map<String, dynamic>) {
      if (rule.length == 1) {
        var opName = rule.keys.first;
        var params = rule.values.first;
        var op = _ops[opName];
        if (op != null) {
          result = _applyOperator(op, params, data);
        } else {
          if (opName.length > 1 && opName[0] == _quickVarPrefix) {
            var varOp = _ops[_quickVarOp];
            if (varOp == null) {
              throw JsonlogicException('No quick access op defined');
            }
            result = _applyOperator(varOp, [opName.substring(1), params], data);
          } else {
            throw JsonlogicException('operator $opName not defined.');
          }
        }
      } else {
        var aggOp = _ops[_defaultAggregator];
        if (aggOp == null) {
          throw JsonlogicException(
              'multiple keys found but default aggregator not defined');
        }
        result = _applyOperatorWithParamMap(aggOp, rule, data);
      }
    }
    return result;
  }

  dynamic _applyOperator(Operator op, dynamic params, dynamic data) {
    var paramRules = [];
    if (params is List) {
      paramRules = params;
    } else {
      paramRules = [params];
    }
    return op(_apply, data, paramRules);
  }

  dynamic _applyOperatorWithParamMap(
      Operator op, Map<String, dynamic> params, dynamic data) {
    var paramRules = <Map<String, dynamic>>[];
    params.forEach((key, value) {
      paramRules.add({key: value});
    });
    return op(_apply, data, paramRules);
  }
}
