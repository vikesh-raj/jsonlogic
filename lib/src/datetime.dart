import 'dart:math';

import 'package:jsonlogic/src/errors.dart';
import 'package:jsonlogic/src/numeric.dart';

import 'interface.dart';

DateTime? getDateTime(dynamic arg) {
  if (arg == null) {
    return null;
  } else if (arg is DateTime) {
    return arg;
  } else if (arg is String && !isNumber(arg)) {
    try {
      return DateTime.parse(arg);
    } on FormatException {
      return null;
    }
  }

  return null;
}

dynamic reduceOperateDateTime(
  DateTime? Function(DateTime dt1, DateTime dt2) operation,
  Applier applier,
  dynamic data,
  List params,
) {
  // This variable will hold the result of the last successful operation or the first DateTime.
  DateTime? result;

  for (var param in params) {
    var value = applier(param, data);
    var currentDateTime = getDateTime(value);

    // If the current value is not a valid DateTime, return null to indicate failure.
    if (currentDateTime == null) {
      return null;
    }

    if (result != null) {
      result = operation(result, currentDateTime);

      if (result == null) {
        return null;
      }
    } else {
      // Initialize result with the first valid DateTime.
      result = currentDateTime;
    }
  }

  return result;
}

bool dateTimeGreaterOperator(Applier applier, dynamic data, List params) {
  var r = reduceOperateDateTime(
    (a, b) => a.isAfter(b) ? b : null,
    applier,
    data,
    params,
  );
  return r != null;
}

bool dateTimeGreaterEqualOperator(Applier applier, dynamic data, List params) {
  var r = reduceOperateDateTime(
    (a, b) => a.isAfter(b) || a.isAtSameMomentAs(b) ? b : null,
    applier,
    data,
    params,
  );
  return r != null;
}

bool dateTimeLessOperator(Applier applier, dynamic data, List params) {
  var r = reduceOperateDateTime(
    (a, b) => a.isBefore(b) ? b : null,
    applier,
    data,
    params,
  );
  return r != null;
}

bool dateTimeLessEqualOperator(Applier applier, dynamic data, List params) {
  var r = reduceOperateDateTime(
    (a, b) => a.isBefore(b) || a.isAtSameMomentAs(b) ? b : null,
    applier,
    data,
    params,
  );
  return r != null;
}

bool isDateTimeEqualOperator(Applier applier, dynamic data, List params) {
  var r = reduceOperateDateTime(
        (a, b) => a.isAtSameMomentAs(b) ? b : null,
    applier,
    data,
    params,
  );
  return r != null;
}

dynamic nowOperator(Applier applier, dynamic data, List params) {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day, now.hour, now.minute);
}

dynamic currentDateOperator(Applier applier, dynamic data, List params) {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

dynamic dateAddOperator(Applier applier, dynamic data, List params) {
  if (params.length != 3) {
    throw JsonlogicException('date_add requires exactly 3 parameters');
  }

  var v = applier(params[0], data);
  var dateValue = getDateTime(v);
  var amount = applier(params[1], data);
  var interval = applier(params[2], data).toString().toLowerCase();

  if (dateValue is! DateTime || amount is! int) {
    throw JsonlogicException('Invalid parameter types for date_add');
  }

  switch (interval) {
    case "day":
      return addDays(dateValue, amount);
    case "week":
      return addDays(dateValue, amount * 7);
    case "month":
      return addMonths(dateValue, amount);
    case "year":
      return addMonths(dateValue, amount * 12);
    default:
      throw JsonlogicException('Invalid interval type for date_add');
  }
}

DateTime addMonths(DateTime from, int months) {

  final r = months % 12;
  final q = (months - r) ~/ 12;
  var newYear = from.year + q;
  var newMonth = from.month + r;
  if (newMonth > 12) {
    newYear++;
    newMonth -= 12;
  }

  // Adjust the day to fit the new month
  final newDay = min(from.day, _daysInMonth(newYear, newMonth));

  // Return the new DateTime, preserving the UTC/local distinction
  return from.isUtc
      ? DateTime.utc(newYear, newMonth, newDay, from.hour, from.minute,
          from.second, from.millisecond, from.microsecond)
      : DateTime(newYear, newMonth, newDay, from.hour, from.minute, from.second,
          from.millisecond, from.microsecond);
}

int _daysInMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}

DateTime addDays(DateTime date, int amount) {
  return date.add(Duration(days: amount));
}
