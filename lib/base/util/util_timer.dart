//todo timer工具
import 'util_date.dart';

class BaseTimerUtil {
  static const int ONE_MINUTE = 60000;
  static const int ONE_HOUR = 3600000;
  static const int ONE_DAY = 86400000;
  static const int ONE_WEEK = 604800000;

  static const String ONE_SECOND_AGO = "秒前";
  static const String ONE_MINUTE_AGO = "分钟前";
  static const String ONE_HOUR_AGO = "小时前";
  static const String ONE_DAY_AGO = "天前";
  static const String ONE_MONTH_AGO = "月前";
  static const String ONE_YEAR_AGO = "年前";

  static String? formatDateStr(String dateStr,
      {BaseDateType format = BaseDateType.NORMAL}) {
    return BaseDateUtil.getDateStrByDateTime(
        BaseDateUtil.getDateTime(dateStr, isUtc: false),
        format: format);
  }

  static String? format(DateTime? date) {
    int now = DateTime.now().millisecondsSinceEpoch;
    int p = date?.millisecondsSinceEpoch ?? 0;
    int delta = now - p;
    if (delta < 1 * ONE_MINUTE) {
      int seconds = toSeconds(delta);
      return (seconds <= 0 ? 1 : seconds).toString() + ONE_SECOND_AGO;
    }
    if (delta < 60 * ONE_MINUTE) {
      int minutes = toMinutes(delta);
      return (minutes <= 0 ? 1 : minutes).toString() + ONE_MINUTE_AGO;
    }
    if (delta < 24 * ONE_HOUR) {
      int hours = toHours(delta);
      return (hours <= 0 ? 1 : hours).toString() + ONE_HOUR_AGO;
    } else {
      return BaseDateUtil.getDateStrByDateTime(date,
          format: BaseDateType.MONTH_DAY_HOUR_MINUTE);
    }
  }

  static int toSeconds(int date) => (date / 1000).toInt();

  static int toMinutes(int date) => (toSeconds(date) / 60).toInt();

  static int toHours(int date) => (toMinutes(date) / 60).toInt();

  static int toDays(int date) => (toHours(date) / 24).toInt();

  static int toMonths(int date) => (toDays(date) / 30).toInt();

  static int toYears(int date) => (toMonths(date) / 365).toInt();
}
