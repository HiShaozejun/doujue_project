class ObjectUtil {
  static bool isEmptyAny(dynamic? value) {
    return value == null || value == '' || value == 'null';
  }

  static bool isEmptyStr(String? str) => str == null || str.isEmpty;

  static bool isEmptyInt(int? value) => value == null || value == 0;

  static bool isEmptyDouble(double? value) =>
      value == null || value.toInt() == 0;

  static bool isEmptyList(List? list) => list == null || list.isEmpty;

  static bool isEmptyMap(Map? map) => map == null || map.isEmpty;

  static bool isEmpty(Object? object) {
    if (object == null) return true;
    if (object is String && object.isEmpty) {
      return true;
    } else if (object is List && object.isEmpty) {
      return true;
    } else if (object is Map && object.isEmpty) {
      return true;
    }
    return false;
  }

  static bool isNotEmpty(Object? object) => !isEmpty(object);

  //
  static String strToZH_Wu(String? value) =>
      ObjectUtil.isEmptyAny(value) ? '无' : value!;

  static String strToZero(String? value) =>
      ObjectUtil.isEmptyAny(value) ? '0' : value!;

  static int intToZero(int? value) => value ?? 0;

  static String doubleToZero(double? value) =>
      (value == null || value == 0.0) ? '0' : value.toString();

  static String intToStrZero(int? value) => (value ?? 0).toString();

  static int strToIntZero(String? value) => int.parse(value ?? '0');

  static double strToDoubleZero(String? value) => double.parse(value ?? '0');

  static bool twoListIsEqual(List? listA, List? listB) {
    if (listA == listB) return true;
    if (listA == null || listB == null) return false;
    int length = listA.length;
    if (length != listB.length) return false;
    for (int i = 0; i < length; i++) {
      if (!listA.contains(listB[i])) {
        return false;
      }
    }
    return true;
  }

  String getMixStr(List<String?> values, {String? suffix = ' | '}) {
    final nonEmptyValues =
        values.where((value) => value != null && value.isNotEmpty);

    final result = nonEmptyValues.join(suffix!);
    return result.isEmpty ? '' : result;
  }

  static int getLength(Object? value) {
    if (value == null) return 0;
    if (value is String) {
      return value.length;
    } else if (value is List) {
      return value.length;
    } else if (value is Map) {
      return value.length;
    } else {
      return 0;
    }
  }
}
