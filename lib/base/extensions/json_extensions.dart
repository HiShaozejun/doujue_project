extension JSONExtensions on Map<String, dynamic> {
  List<T> formatList<T>(
      String key, T Function(Map<String, dynamic> json) createJson) {
    var listJson = this[key];
    return listJson == null
        ? []
        : List.from(listJson).map((e) => createJson(e)).toList();
  }

  T? formatObject<T>(
      String key, T Function(Map<String, dynamic> json) createJson) {
    var objectJson = this['data'];
    if (objectJson != null) {
      return createJson(objectJson);
    }
    return null;
  }
}
