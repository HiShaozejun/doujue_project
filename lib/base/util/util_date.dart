import 'package:intl/intl.dart';

enum BaseDateType {
  DEFAULT, //yyyy-MM-dd HH:mm:ss.SSS
  NORMAL, //yyyy-MM-dd HH:mm:ss
  YEAR_MONTH_DAY_HOUR_MINUTE, //yyyy-MM-dd HH:mm
  YEAR_MONTH_DAY, //yyyy-MM-dd
  YEAR_MONTH, //yyyy-MM
  YEAR_ONLY, //yyyy
  MONTH_DAY, //MM-dd
  MONTH_DAY_HOUR_MINUTE, //MM-dd HH:mm
  HOUR_MINUTE_SECOND, //HH:mm:ss
  HOUR_MINUTE, //HH:mm

  ZH_DEFAULT, //yyyy年MM月dd日 HH时mm分ss秒SSS毫秒
  ZH_NORMAL, //yyyy年MM月dd日 HH时mm分ss秒  /  timeSeparate: ":" --> yyyy年MM月dd日 HH:mm:ss
  ZH_YEAR_MONTH_DAY_HOUR_MINUTE, //yyyy年MM月dd日 HH时mm分  /  timeSeparate: ":" --> yyyy年MM月dd日 HH:mm
  ZH_YEAR_MONTH_DAY, //yyyy年MM月dd日
  ZH_YEAR_MONTH, //yyyy年MM月
  ZH_YEAR_ONLY, //yyyy年
  ZH_MONTH_DAY, //MM月dd日
  ZH_MONTH_DAY_HOUR_MINUTE, //MM月dd日 HH时mm分  /  timeSeparate: ":" --> MM月dd日 HH:mm
  ZH_HOUR_MINUTE_SECOND, //HH时mm分ss秒
  ZH_HOUR_MINUTE, //HH时mm分
}

/// 一些常用格式参照。可以自定义格式，例如："yyyy/MM/dd HH:mm:ss"，"yyyy/M/d HH:mm:ss"。
/// 格式要求
/// year -> yyyy/yy   month -> MM/M    day -> dd/d
/// hour -> HH/H      minute -> mm/m   second -> ss/s
class DataFormats {
  static const String full = "yyyy-MM-dd HH:mm:ss";
  static const String y_mo_d_h_m = "yyyy-MM-dd HH:mm";
  static const String y_mo_d = "yyyy-MM-dd";
  static const String y_mo = "yyyy-MM";
  static const String mo_d = "MM-dd";
  static const String mo_d_h_m = "MM-dd HH:mm";
  static const String h_m_s = "HH:mm:ss";
  static const String h_m = "HH:mm";

  static const String zh_full = "yyyy年MM月dd日 HH时mm分ss秒";
  static const String zh_y_mo_d_h_m = "yyyy年MM月dd日 HH时mm分";
  static const String zh_y_mo_d = "yyyy年MM月dd日";
  static const String zh_y_mo = "yyyy年MM月";
  static const String zh_mo_d = "MM月dd日";
  static const String zh_mo_d_h_m = "MM月dd日 HH时mm分";
  static const String zh_h_m_s = "HH时mm分ss秒";
  static const String zh_h_m = "HH时mm分";
}

/// month->days.
const Map<int, int> MONTH_DAY = {
  1: 31,
  2: 28,
  3: 31,
  4: 30,
  5: 31,
  6: 30,
  7: 31,
  8: 31,
  9: 30,
  10: 31,
  11: 30,
  12: 31,
};

/// Date Util.
class BaseDateUtil {
  /// get DateTime By DateStr.
  static DateTime? getDateTime(String dateStr, {bool isUtc = false}) {
    DateTime? dateTime = DateTime.tryParse(dateStr);
    if (isUtc) {
      dateTime = dateTime?.toUtc();
    } else {
      dateTime = dateTime?.toLocal();
    }
    return dateTime;
  }

  /// get DateTime By Milliseconds.
  static DateTime? getDateTimeByMs(int? milliseconds, {bool isUtc = false}) =>
      milliseconds == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);

  /// get DateMilliseconds By DateStr.
  static int? getDateMsByTimeStr(String dateStr) {
    DateTime? dateTime = DateTime.tryParse(dateStr);
    return dateTime == null ? null : dateTime.millisecondsSinceEpoch;
  }

  static int getNowDateMs() => DateTime.now().millisecondsSinceEpoch;

  /// get Now Date Str.(yyyy-MM-dd HH:mm:ss)
  static String? getNowDateStr() => getDateStrByDateTime(DateTime.now());

  static String? getDateStrByTimeStr(
    String dateStr, {
    BaseDateType format = BaseDateType.NORMAL,
    String? dateSeparate,
    String? timeSeparate,
    bool isUtc = false,
  }) {
    return getDateStrByDateTime(getDateTime(dateStr, isUtc: isUtc),
        format: format, dateSeparate: dateSeparate, timeSeparate: timeSeparate);
  }

  static String? getDateStrByMs(int milliseconds,
      {BaseDateType format = BaseDateType.NORMAL,
      String? dateSeparate,
      String? timeSeparate,
      bool isUtc = false}) {
    DateTime? dateTime = getDateTimeByMs(milliseconds, isUtc: isUtc);
    return getDateStrByDateTime(dateTime,
        format: format, dateSeparate: dateSeparate, timeSeparate: timeSeparate);
  }

  /// get DateStr By DateTime.
  static String? getDateStrByDateTime(DateTime? dateTime,
      {BaseDateType format = BaseDateType.NORMAL,
      String? dateSeparate,
      String? timeSeparate}) {
    if (dateTime == null) return null;
    String dateStr = dateTime.toString();
    if (isZHFormat(format)) {
      dateStr =
          formatZHDateTime(dateStr, format: format, timeSeparate: timeSeparate);
    } else {
      dateStr = formatDateTime(dateStr,
          format: format,
          dateSeparate: dateSeparate,
          timeSeparate: timeSeparate);
    }
    return dateStr;
  }

  /// format ZH DateTime.
  static String formatZHDateTime(String? time,
      {BaseDateType format = BaseDateType.NORMAL, String? timeSeparate}) {
    if (time == null) return '';
    time = convertToZHDateTimeString(time, timeSeparate);
    switch (format) {
      case BaseDateType.ZH_NORMAL: //yyyy年MM月dd日 HH时mm分ss秒
        time = time.substring(
            0,
            "yyyy年MM月dd日 HH时mm分ss秒".length -
                (timeSeparate == null || timeSeparate.isEmpty ? 0 : 1));
        break;
      case BaseDateType.ZH_YEAR_MONTH_DAY_HOUR_MINUTE: //yyyy年MM月dd日 HH时mm分
        time = time.substring(
            0,
            "yyyy年MM月dd日 HH时mm分".length -
                (timeSeparate == null || timeSeparate.isEmpty ? 0 : 1));
        break;
      case BaseDateType.ZH_YEAR_MONTH_DAY: //yyyy年MM月dd日
        time = time.substring(0, "yyyy年MM月dd日".length);
        break;
      case BaseDateType.ZH_YEAR_MONTH: //yyyy年MM月
        time = time.substring(0, "yyyy年MM月".length);
        break;
      case BaseDateType.ZH_YEAR_ONLY: //yyyy年
        time = time.substring(0, "yyyy年".length);
        break;
      case BaseDateType.ZH_MONTH_DAY: //MM月dd日
        time = time.substring("yyyy年".length, "yyyy年MM月dd日".length);
        break;
      case BaseDateType.ZH_MONTH_DAY_HOUR_MINUTE: //MM月dd日 HH时mm分
        time = time.substring(
            "yyyy年".length,
            "yyyy年MM月dd日 HH时mm分".length -
                (timeSeparate == null || timeSeparate.isEmpty ? 0 : 1));
        break;
      case BaseDateType.ZH_HOUR_MINUTE_SECOND: //HH时mm分ss秒
        time = time.substring(
            "yyyy年MM月dd日 ".length,
            "yyyy年MM月dd日 HH时mm分ss秒".length -
                (timeSeparate == null || timeSeparate.isEmpty ? 0 : 1));
        break;
      case BaseDateType.ZH_HOUR_MINUTE: //HH时mm分
        time = time.substring(
            "yyyy年MM月dd日 ".length,
            "yyyy年MM月dd日 HH时mm分".length -
                (timeSeparate == null || timeSeparate.isEmpty ? 0 : 1));
        break;
      default:
        break;
    }
    return time;
  }

  /// format DateTime.
  static String formatDateTime(String? time,
      {BaseDateType format = BaseDateType.NORMAL,
      String? dateSeparate = "-",
      String? timeSeparate = ":"}) {
    if (time == null) return '';
    switch (format) {
      case BaseDateType.NORMAL: //yyyy-MM-dd HH:mm:ss
        time = time.substring(0, "yyyy-MM-dd HH:mm:ss".length);
        break;
      case BaseDateType.YEAR_MONTH_DAY_HOUR_MINUTE: //yyyy-MM-dd HH:mm
        time = time.substring(0, "yyyy-MM-dd HH:mm".length);
        break;
      case BaseDateType.YEAR_MONTH_DAY: //yyyy-MM-dd
        time = time.substring(0, "yyyy-MM-dd".length);
        break;
      case BaseDateType.YEAR_MONTH: //yyyy-MM
        time = time.substring(0, "yyyy-MM".length);
        break;
      case BaseDateType.YEAR_ONLY: //yyyy
        time = time.substring(0, "yyyy".length);
        break;
      case BaseDateType.MONTH_DAY: //MM-dd
        time = time.substring("yyyy-".length, "yyyy-MM-dd".length);
        break;
      case BaseDateType.MONTH_DAY_HOUR_MINUTE: //MM-dd HH:mm
        time = time.substring("yyyy-".length, "yyyy-MM-dd HH:mm".length);
        break;
      case BaseDateType.HOUR_MINUTE_SECOND: //HH:mm:ss
        time =
            time.substring("yyyy-MM-dd ".length, "yyyy-MM-dd HH:mm:ss".length);
        break;
      case BaseDateType.HOUR_MINUTE: //HH:mm
        time = time.substring("yyyy-MM-dd ".length, "yyyy-MM-dd HH:mm".length);
        break;
      default:
        break;
    }
    time = dateTimeSeparate(time, dateSeparate, timeSeparate);
    return time;
  }

  /// is format to ZH DateTime String
  static bool isZHFormat(BaseDateType format) =>
      format == BaseDateType.ZH_DEFAULT ||
      format == BaseDateType.ZH_NORMAL ||
      format == BaseDateType.ZH_YEAR_MONTH_DAY_HOUR_MINUTE ||
      format == BaseDateType.ZH_YEAR_MONTH_DAY ||
      format == BaseDateType.ZH_YEAR_MONTH ||
      format == BaseDateType.ZH_MONTH_DAY ||
      format == BaseDateType.ZH_MONTH_DAY_HOUR_MINUTE ||
      format == BaseDateType.ZH_HOUR_MINUTE_SECOND ||
      format == BaseDateType.ZH_HOUR_MINUTE;

  /// convert To ZH DateTime String
  static String convertToZHDateTimeString(String time, String? timeSeparate) {
    time = time.replaceFirst("-", "年");
    time = time.replaceFirst("-", "月");
    time = time.replaceFirst(" ", "日 ");
    if (timeSeparate == null || timeSeparate.isEmpty) {
      time = time.replaceFirst(":", "时");
      time = time.replaceFirst(":", "分");
      time = time.replaceFirst(".", "秒");
      time = time + "毫秒";
    } else {
      time = time.replaceAll(":", timeSeparate);
    }
    return time;
  }

  /// date Time Separate.
  static String dateTimeSeparate(
      String time, String? dateSeparate, String? timeSeparate) {
    if (dateSeparate != null) {
      time = time.replaceAll("-", dateSeparate);
    }
    if (timeSeparate != null) {
      time = time.replaceAll(":", timeSeparate);
    }
    return time;
  }

  /// format date by milliseconds. milliseconds 日期毫秒
  static String? formatDateMs(int milliseconds,
          {bool isUtc = false, String? format}) =>
      formatDate(getDateTimeByMs(milliseconds, isUtc: isUtc), format: format);

  /// format date by date str.
  static String formatDateStr(String dateStr,
          {bool isUtc = false, String? format}) =>
      formatDate(getDateTime(dateStr, isUtc: isUtc), format: format);

  /// format date by DateTime.
  /// format 转换格式(已提供常用格式 DataFormats，可以自定义格式："yyyy/MM/dd HH:mm:ss")
  /// 格式要求
  /// year -> yyyy/yy   month -> MM/M    day -> dd/d
  /// hour -> HH/H      minute -> mm/m   second -> ss/s
  static String formatDate(DateTime? dateTime,
      {bool isUtc = false, String? format}) {
    if (dateTime == null) return "";
    format = format ?? DataFormats.full;
    if (format.contains("yy")) {
      String year = dateTime.year.toString();
      if (format.contains("yyyy")) {
        format = format.replaceAll("yyyy", year);
      } else {
        format = format.replaceAll(
            "yy", year.substring(year.length - 2, year.length));
      }
    }

    format = _comFormat(dateTime.month, format, 'M', 'MM');
    format = _comFormat(dateTime.day, format, 'd', 'dd');
    format = _comFormat(dateTime.hour, format, 'H', 'HH');
    format = _comFormat(dateTime.minute, format, 'm', 'mm');
    format = _comFormat(dateTime.second, format, 's', 'ss');
    format = _comFormat(dateTime.millisecond, format, 'S', 'SSS');

    return format;
  }

  /// com format.
  static String _comFormat(
      int value, String format, String single, String full) {
    if (format.contains(single)) {
      if (format.contains(full)) {
        format =
            format.replaceAll(full, value < 10 ? '0$value' : value.toString());
      } else {
        format = format.replaceAll(single, value.toString());
      }
    }
    return format;
  }

  /// get WeekDay By Milliseconds.
  static String? getWeekDayByMs(int milliseconds, {bool isUtc = false}) {
    DateTime? dateTime = getDateTimeByMs(milliseconds, isUtc: isUtc);
    return getWeekDay(dateTime);
  }

  /// get ZH WeekDay By Milliseconds.
  static String? getZHWeekDayByMs(int milliseconds, {bool isUtc = false}) {
    DateTime? dateTime = getDateTimeByMs(milliseconds, isUtc: isUtc);
    return getZHWeekDay(dateTime);
  }

  /// get WeekDay.
  static String? getWeekDay(DateTime? dateTime) {
    if (dateTime == null) return null;
    String weekday;
    switch (dateTime.weekday) {
      case 1:
        weekday = "Monday";
        break;
      case 2:
        weekday = "Tuesday";
        break;
      case 3:
        weekday = "Wednesday";
        break;
      case 4:
        weekday = "Thursday";
        break;
      case 5:
        weekday = "Friday";
        break;
      case 6:
        weekday = "Saturday";
        break;
      case 7:
        weekday = "Sunday";
        break;
      default:
        weekday = "Unknown";
        break;
    }
    return weekday;
  }

  /// get ZH WeekDay.
  static String? getZHWeekDay(DateTime? dateTime) {
    if (dateTime == null) return null;
    String weekday;
    switch (dateTime.weekday) {
      case 1:
        weekday = "星期一";
        break;
      case 2:
        weekday = "星期二";
        break;
      case 3:
        weekday = "星期三";
        break;
      case 4:
        weekday = "星期四";
        break;
      case 5:
        weekday = "星期五";
        break;
      case 6:
        weekday = "星期六";
        break;
      case 7:
        weekday = "星期日";
        break;
      default:
        weekday = "Unknown";
        break;
    }
    return weekday;
  }

  /// Return whether it is leap year.
  static bool isLeapYearByDateTime(DateTime dateTime) =>
      isLeapYearByYear(dateTime.year);

  /// Return whether it is leap year.
  static bool isLeapYearByYear(int year) =>
      year % 4 == 0 && year % 100 != 0 || year % 400 == 0;

  /// is yesterday by millis.
  static bool isYesterdayByMillis(int millis, int locMillis) => isYesterday(
      DateTime.fromMillisecondsSinceEpoch(millis),
      DateTime.fromMillisecondsSinceEpoch(locMillis));

  /// is yesterday by dateTime.
  static bool isYesterday(DateTime dateTime, DateTime locDateTime) {
    if (yearIsEqual(dateTime, locDateTime)) {
      int spDay = getDayOfYear(locDateTime) - getDayOfYear(dateTime);
      return spDay == 1;
    } else {
      return ((locDateTime.year - dateTime.year == 1) &&
          dateTime.month == 12 &&
          locDateTime.month == 1 &&
          dateTime.day == 31 &&
          locDateTime.day == 1);
    }
  }

  /// get day of year.
  static int getDayOfYearByMillis(int millis, {bool isUtc = false}) =>
      getDayOfYear(DateTime.fromMillisecondsSinceEpoch(millis, isUtc: isUtc));

  /// get day of year.
  static int getDayOfYear(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;
    int days = dateTime.day;
    for (int i = 1; i < month; i++) {
      days = days + MONTH_DAY[i]!;
    }
    if (isLeapYearByYear(year) && month > 2) {
      days = days + 1;
    }
    return days;
  }

  /// year is equal.
  static bool yearIsEqualByMillis(int millis, int locMillis) => yearIsEqual(
      DateTime.fromMillisecondsSinceEpoch(millis),
      DateTime.fromMillisecondsSinceEpoch(locMillis));

  /// year is equal.
  static bool yearIsEqual(DateTime dateTime, DateTime locDateTime) =>
      dateTime.year == locDateTime.year;

  static bool dayIsEqual(DateTime dateTime, DateTime locDateTime) =>
      dateTime.year == locDateTime.year &&
      dateTime.month == locDateTime.month &&
      dateTime.day == locDateTime.day;

  /// is today.
  static bool isToday(int milliseconds, {bool isUtc = false}) {
    if (milliseconds == null || milliseconds == 0) return false;
    DateTime old =
        DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    DateTime now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    return old.year == now.year && old.month == now.month && old.day == now.day;
  }

  /// is cur Week.
  static bool isWeek(int milliseconds, {bool isUtc = false}) {
    if (milliseconds == null || milliseconds <= 0) {
      return false;
    }
    DateTime _old =
        DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    DateTime _now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    DateTime old =
        _now.millisecondsSinceEpoch > _old.millisecondsSinceEpoch ? _old : _now;
    DateTime now =
        _now.millisecondsSinceEpoch > _old.millisecondsSinceEpoch ? _now : _old;
    return (now.weekday >= old.weekday) &&
        (now.millisecondsSinceEpoch - old.millisecondsSinceEpoch <=
            7 * 24 * 60 * 60 * 1000);
  }

  static String formatYMD(DateTime date) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    return format.format(date);
  }

  static String formatYMDHMS(DateTime date) {
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
    return format.format(date);
  }


  static int get curTimeMS => DateTime.now().millisecondsSinceEpoch;
}
