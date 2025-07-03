import 'package:dio/dio.dart';
import 'package:djqs/base/ui/base_widget.dart';

class BaseExceptionInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.badResponse:
        toast('网络请求出错');
        break;
      case DioExceptionType.cancel:
        toast('网络请求取消');
        break;
      case DioExceptionType.connectionTimeout:
        toast('网络连接超时');
        break;
      case DioExceptionType.connectionError:
        toast('网络连接错误');
        break;
      case DioExceptionType.receiveTimeout:
        toast('网络响应超时');
        break;
      case DioExceptionType.sendTimeout:
        toast('网络请求超时');
        break;
      case DioExceptionType.badCertificate:
        toast('网络证书错误');
        break;
      default:
        toast('网络请求出错，请稍后尝试');
        break;
    }
    return super.onError(err, handler);
  }

  void toast(String str) => BaseWidgetUtil.showToast(str);
}
