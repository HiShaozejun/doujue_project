import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BaseLogUtil {
  BaseLogUtil._internal();

  factory BaseLogUtil() => _instance;

  static late final BaseLogUtil _instance = BaseLogUtil._internal();

  Logger? loggerFull;
  Logger? logger;

  bool? _isDebug;

  void init({@required bool isDebug = true}) {
    _isDebug = isDebug;
    loggerFull = _isDebug!
        ? Logger(
            printer: PrettyPrinter(
                methodCount: 0,
                errorMethodCount: 8,
                lineLength: 120,
                colors: true,
                printEmojis: false,
                printTime: true),
          )
        : null;
    logger = _isDebug!
        ? Logger(
            printer: PrettyPrinter(
                methodCount: 0, printTime: true, printEmojis: false),
          )
        : null;
  }

  void d(dynamic obj) => logger?.d(obj);

  void i(dynamic obj, {String tag = ''}) =>
      logger?.i('${tag + ':' + obj.toString()}');

  void w(String obj) => loggerFull?.w(obj);

  void t(dynamic obj, {String tag = ''}) =>
      logger?.d('${tag + ':' + obj.toString()}');

  void e(dynamic obj, {StackTrace? stackTrace}) =>
      loggerFull?.e(obj, stackTrace: stackTrace);
}
