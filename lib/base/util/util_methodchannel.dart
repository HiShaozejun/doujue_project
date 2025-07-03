import 'package:flutter/services.dart';

class BaseMCUtil {
  static const MethodChannel androidMC = MethodChannel('djqs_android');

  static Future<void> backDesktop() async =>
      await androidMC.invokeMethod('backHome');
}
