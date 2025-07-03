import 'package:djqs/base/ui/base_widget.dart';

import 'util_object.dart';

/// id card province dict.
const List<String> ID_CARD_PROVINCE_DICT = const [
  '11=北京',
  '12=天津',
  '13=河北',
  '14=山西',
  '15=内蒙古',
  '21=辽宁',
  '22=吉林',
  '23=黑龙江',
  '31=上海',
  '32=江苏',
  '33=浙江',
  '34=安徽',
  '35=福建',
  '36=江西',
  '37=山东',
  '41=河南',
  '42=湖北',
  '43=湖南',
  '44=广东',
  '45=广西',
  '46=海南',
  '50=重庆',
  '51=四川',
  '52=贵州',
  '53=云南',
  '54=西藏',
  '61=陕西',
  '62=甘肃',
  '63=青海',
  '64=宁夏',
  '65=新疆',
  '71=台湾',
  '81=香港',
  '82=澳门',
  '91=国外',
];

class BaseStrUtil {
  static String mapToJointStr(Map<String, dynamic> map) {
    List<String> parts = [];
    map.entries.forEach((entry) {
      parts.add('${entry.key}=${entry.value}');
    });
    return parts.join('&');
  }

  static bool isUrl(String? url) {
    try {
      Uri uri = Uri.parse(url ?? '');
      return uri.isScheme('http') || uri.isScheme('https');
    } catch (e) {
      return false;
    }
  }

  static validateName(name) {
    const _regExp = r"^[\u4e00-\u9fa5]+(·[\u4e00-\u9fa5]+)*$"; //银行卡姓名
    if (RegExp(_regExp).firstMatch(name) == null) {
      BaseWidgetUtil.showToast('持卡人姓名输入不正确');
      return false;
    }
    return true;
  }

  static validateMobile(String? mobile) {
    if (mobile == null || mobile.trim() == '') {
      BaseWidgetUtil.showToast('请输入手机号!');
      return false;
    }
    const _regExp =
        r"^(13[0-9]|14[01456879]|15[0-3,5-9]|16[2567]|17[0-8]|18[0-9]|19[0-3,5-9])\d{8}$"; //11位手机号码正则
    if (RegExp(_regExp).firstMatch(mobile) == null) {
      BaseWidgetUtil.showToast('请输入正确的手机号');
      return false;
    }
    return true;
  }

  ///各式化银行卡号
  static getPayCodeStyleStr(String? code) {
    if (ObjectUtil.isEmptyAny(code) || (code!.length) < 15) {
      return '';
    }
    code = code!.replaceRange(4, 12, '********');
    int length = code.length;
    int count = length ~/ 4;
    int shengYu = length % 4;
    String result = '';
    if (length < 4) {
      return code;
    } else {
      for (int i = 0; i < count; i++) {
        String temp = code.substring(i * 4, (i + 1) * 4);
        result += temp + " ";
      }
      result += code.substring(length - shengYu, length);
      return result;
    }
  }

  static getPayCardStr(String code) {
    if (ObjectUtil.isEmptyAny(code) || code.length < 15) {
      return '';
    }
    final int length = code.length;
    final int replaceLength = length;
    final String replacement =
        List<String>.generate((replaceLength / 4).ceil(), (int _) => '**** ')
            .join('');
    return code.replaceRange(0, replaceLength, replacement);
  }

  static String getAgeByBirthday(String? birthYear) {
    if (birthYear != null && birthYear.length == 4) {
      DateTime data = DateTime.now();
      int year = data.year;
      int birthY = int.parse(birthYear);
      return (year - birthY).toString();
    }

    return '';
  }

  static getEncryptNumber(String number,
      {int preIndex = 4, int lastIndex = 3}) {
    int length = number.length;
    if (length == 0) return '';

    int last = length - lastIndex;
    String markStr = '*' * (last - preIndex);
    String maskedString = number.replaceRange(preIndex, last, markStr);
    return maskedString;
  }

  static const String regexNumber = "^-?[0-9]+";

  static const String regexNumberDecimal = "^[-+]?[0-9]+(\\.[0-9]+)?\$";

  static const String regexMobileSimple = "^[1]\\d{10}\$";

  static const String regexTel = "^0\\d{2,3}[- ]?\\d{7,8}";

  /// Regex of exact mobile.
  /// <p>china mobile: 134(0-8), 135, 136, 137, 138, 139, 147, 150, 151, 152, 157, 158, 159, 178, 182, 183, 184, 187, 188, 198</p>
  /// <p>china unicom: 130, 131, 132, 145, 155, 156, 166, 171, 175, 176, 185, 186</p>
  /// <p>china telecom: 133, 153, 173, 177, 180, 181, 189, 199</p>
  /// <p>global star: 1349</p>
  /// <p>virtual operator: 170</p>
  static const String regexMobileExact =
      "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(16[6])|(17[0,1,3,5-8])|(18[0-9])|(19[1,8,9]))\\d{8}\$";

  /// Regex of telephone number.

  static const String regexIdCard15 =
      "^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}\$";

  static const String regexIdCard18 =
      "^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9Xx])\$";

  static const String regexEmail =
      "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

  static const String regexZh = "[\\u4e00-\\u9fa5]";

  /// Regex of date which pattern is "yyyy-MM-dd".
  static const String regexDate =
      "^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)\$";

  static const String regexIp =
      "((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";

  static final Map<String, String> cityMap = new Map();

  static bool isMobileSimple(String input) => matches(regexMobileSimple, input);

  static bool isMobileExact(String input) => matches(regexMobileExact, input);

  static bool isTel(String input) => matches(regexTel, input);

  static bool isEmail(String input) => matches(regexEmail, input);

  static bool isZh(String input) => '〇' == input || matches(regexZh, input);

  static bool isDate(String input) => matches(regexDate, input);

  static bool isIP(String input) => matches(regexIp, input);

  static bool isIDCard(String input) {
    if (input != null && input.length == 15) {
      return isIDCard15(input);
    }
    if (input != null && input.length == 18) {
      return isIDCard18Exact(input);
    }
    return false;
  }

  static bool isIDCard15(String input) => matches(regexIdCard15, input);

  static bool isIDCard18(String input) => matches(regexIdCard18, input);

  static bool isIDCard18Exact(String input) {
    if (isIDCard18(input)) {
      List<int> factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
      List<String> suffix = [
        '1',
        '0',
        'X',
        '9',
        '8',
        '7',
        '6',
        '5',
        '4',
        '3',
        '2'
      ];
      if (cityMap.isEmpty) {
        List<String> list = ID_CARD_PROVINCE_DICT;
        List<MapEntry<String, String>> mapEntryList = [];
        for (int i = 0, length = list.length; i < length; i++) {
          List<String> tokens = list[i].trim().split("=");
          MapEntry<String, String> mapEntry =
              new MapEntry(tokens[0], tokens[1]);
          mapEntryList.add(mapEntry);
        }
        cityMap.addEntries(mapEntryList);
      }
      if (cityMap[input.substring(0, 2)] != null) {
        int weightSum = 0;
        for (int i = 0; i < 17; ++i) {
          weightSum += (input.codeUnitAt(i) - '0'.codeUnitAt(0)) * factor[i];
        }
        int idCardMod = weightSum % 11;
        String idCardLast = String.fromCharCode(input.codeUnitAt(17));
        return idCardLast == suffix[idCardMod];
      }
    }
    return false;
  }

  static bool matches(String regex, String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(regex).hasMatch(input);
  }

  static String strWithMask(String? str, {int visibleDigits = 3}) {
    if (ObjectUtil.isEmptyStr(str)) return '';

    final int maskedDigits = str!.length - (visibleDigits * 2);
    if (maskedDigits <= 0) return str;

    final RegExp pattern = RegExp(
        "^(.{0,$visibleDigits})(.{0,$maskedDigits})(.{0,$visibleDigits})");
    String maskedPart = str.replaceAllMapped(pattern, (match) {
      return '${match.group(1)}${'*' * maskedDigits}${match.group(3)}';
    });

    return maskedPart;
  }
}
