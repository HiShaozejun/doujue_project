import 'dart:io';

import 'package:dio/dio.dart';
import 'package:djqs/base/ui/base_widget.dart';

extension Exception on Object {
  void onFailed(dynamic onError, {Function(String? message)? callback}) {
    if (onError is HttpException) {
      callback?.call(onError.message);
    } else if (onError is DioError) {
      callback?.call(onError.message);
    }
  }

  void onFailedToast(dynamic onError) {
    if (onError is HttpException) {
      BaseWidgetUtil.showErrorToast(onError.message);
    } else if (onError is DioError) {
      BaseWidgetUtil.showErrorToast(onError.message ?? '');
    }
  }
}
