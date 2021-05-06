// truth returns true for any truthy-value. null, false, 0, empty list or map
// are false. Remaining values are all true.
bool truth(dynamic v) {
  if (v == null) {
    return false;
  } else if (v is bool) {
    return v;
  } else if (v is num) {
    return v != 0;
  } else if (v is String) {
    return v.isNotEmpty;
  } else if (v is List || v is Map) {
    return v.isNotEmpty;
  }
  return true;
}
