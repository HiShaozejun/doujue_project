class BaseNumUtil {
  /// 数字千位符，小数点，金额格式化
  static String formatNum(num, {point = 2, bool forcePoint = true}) {
    if (num != null && num != "null") {
      String str = double.parse(num.toString()).toString();

      List<String> sub = str.split('.');

      List<String> val = [];
      if (sub.isNotEmpty) {
        val = List.from(sub[0].split(''));
      }
      List<String> points = [];
      if (sub.length > 1) {
        points = List.from(sub[1].split(''));
      }
      for (int index = 0, i = val.length - 1; i >= 0; index++, i--) {
        // 除以三没有余数、不等于零并且不等于1 就加个逗号
        if (index % 3 == 0 && index != 0 && val[i] != '-') {
          val[i] = val[i] + ',';
        }
      }

      for (int i = 0; i <= point - points.length; i++) {
        points.add('0');
      }
      if (points.length > point) {
        points = points.sublist(0, point);
      }

      if (points.isNotEmpty &&
          (forcePoint || (!forcePoint && int.parse(points.join("")) > 0))) {
        return '${val.join('')}.${points.join('')}';
      } else {
        return val.join('');
      }
    } else {
      return "0.00";
    }
  }

  /// The parameter [fractionDigits] must be an integer satisfying: `0 <= fractionDigits <= 20`.
  static num? getNumByValueStr(String valueStr, {int? fractionDigits}) {
    double? value = double.tryParse(valueStr);
    return fractionDigits == null
        ? value
        : getNumByValueDouble(value, fractionDigits);
  }

  /// The parameter [fractionDigits] must be an integer satisfying: `0 <= fractionDigits <= 20`.
  static num? getNumByValueDouble(double? value, int? fractionDigits) {
    if (value == null) return null;
    String valueStr = value.toStringAsFixed(fractionDigits!);
    return fractionDigits == 0
        ? int.tryParse(valueStr)
        : double.tryParse(valueStr);
  }

  /// get int by value str.
  static int getIntByValueStr(String valueStr, {int defValue = 0}) =>
      int.tryParse(valueStr) ?? defValue;

  /// get double by value str.
  static double getDoubleByValueStr(String valueStr, {double defValue = 0}) =>
      double.tryParse(valueStr) ?? defValue;

  ///isZero
  static bool isZero(num value) => value == null || value == 0;

  //保留两位小数，但去掉末尾多余的 .00 或 .0
  static String formatDecimalPlace(double value) {
    return value.toStringAsFixed(2).replaceAll(RegExp(r"\.?0+$"), "");
  }
}
