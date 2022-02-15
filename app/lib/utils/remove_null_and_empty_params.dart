Map<String, dynamic>? removeNullAndEmptyParams(
    Map<String, dynamic>? mapToEdit) {
  // Remove all null values; they cause validation errors
  final keys = mapToEdit!.keys.toList(growable: false);
  for (String key in keys) {
    if (mapToEdit[key] == null) {
      mapToEdit.remove(key);
    } else if (mapToEdit[key] is String) {
      String? value = mapToEdit[key];
      if (value == null || value.isEmpty) {
        mapToEdit.remove(key);
      }
    } else if (mapToEdit[key] is Map) {
      Map<String, dynamic>? value = mapToEdit[key];
      if (value == null) {
        mapToEdit.remove(key);
      } else if (value is Map) {
        removeNullAndEmptyParams(value);
      }
    }

  }
  return mapToEdit;
}
