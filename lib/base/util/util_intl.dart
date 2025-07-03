import 'dart:async';
import 'dart:convert';

import 'package:djqs/base/util/util_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// 本地化字符扩展函数
/// 通过字符key.localized() 获取本地化字符
extension LocalizedStringExtension on String {
  String localized() => Localizations.instance.text(this);
}

/// 本地化字符文件处理
class Localizations {
  final Map<String, dynamic> _localisedValues = {};

  static final Localizations _singleton = Localizations._internal();

  Localizations._internal();

  static Localizations get instance => _singleton;

  // 本地字符缓存

  Future<Localizations> load(
      String languageCode, List<String> fileNames) async {
    try {
      for (String fileName in fileNames) {
        await _appendValues(fileName, languageCode);
      }
    } catch (e) {
      BaseLogUtil().d("load assets/local/$languageCode/fileName.json error $e");
    }
    return this;
  }

  /// 加载语言json内容填充到本地 [_localisedValues]
  Future<void> _appendValues(String fileName, String languageCode) async {
    try {
      String jsonContent = await rootBundle
          .loadString("assets/locale/$languageCode/$fileName.json");

      Map<String, dynamic> map = json.decode(jsonContent);
      if (map.isNotEmpty) {
        _localisedValues.addAll(map);
      }
    } catch (e) {
      BaseLogUtil().d("load:${fileName}_$languageCode.json error $e");
    }
  }

  String text(String key) => _localisedValues[key] ?? key;
}

/// 本地化代理加载器
class CommonLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  static const Locale _defaultLocale = Locale("zh");

  // 支持的字符语言集合
  static final List<String> _supportLanguageCodeList = ['zh'];

  CommonLocalizationsDelegate._internal();

  static final CommonLocalizationsDelegate _instance =
      CommonLocalizationsDelegate._internal();

  static CommonLocalizationsDelegate getInstance() => _instance;

  @override
  bool isSupported(Locale locale) =>
      _supportLanguageCodeList.contains(locale.languageCode);

  @override
  SynchronousFuture<CupertinoLocalizations> load(
    Locale locale,
  ) {
    return SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations());
  }

  Future<void> loadFile(Locale locale, List<String> fileNames) async {
    await load(locale);
    await Localizations.instance.load(locale.languageCode, fileNames);
  }

  @override
  bool shouldReload(CommonLocalizationsDelegate old) => false;

  // 初始化本地化字符
  Locale initLocalizations(List<String> fileNames, {Locale? locale}) {
    // 支持的语言
    if (isSupported(locale ?? _defaultLocale)) {
      loadFile(locale ?? _defaultLocale, fileNames);
      return locale ?? _defaultLocale;
    }

    // 不支持直接返回默认语言
    loadFile(_defaultLocale, fileNames);
    return _defaultLocale;
  }
}
