import 'package:dio/dio.dart';

import 'base_net_const.dart';

class BaseCookieInterceptor extends Interceptor {
  static const String _HEADER_COOKIE_KEY = "Cookie"; // 请求头设置cookie键名
  static const String _SET_COOKIE_KEY = "set-cookie"; // 包含cookie的response取值键名
  static const String _CONTAINER_COOKIE_URI = "/lg/"; // 链接中包含lg则需要设置cookie
  static const String _SAVE_TOKEN_KEY = "save-token"; // 保存cookie 键名

  static const String _CONTAINER_LOGIN_URI = "user/login";
  static const String _CONTAINER_REGISTER_URI = "user/register";
  static const String _CONTAINER_LOGOUT_URI = "user/logout";

  String _cookie = "";

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String uri = options.uri.toString();
    // 当前请求为baseUri
    // if (uri.contains(ApiConstants.BASE_URI)) {
    //   if (uri.contains(_CONTAINER_COOKIE_URI)) {
    //     if (cookie.isEmpty) {
    //       cookie = await Preferences.get(_SAVE_TOKEN_KEY);
    //     }
    //     options.headers[_HEADER_COOKIE_KEY] = cookie;
    //   }
    // }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    String uri = response.realUri.toString();
    if (uri.contains(BaseNetConst().commonUrl)) {
      if (uri.contains(RegExp(_CONTAINER_LOGIN_URI)) ||
          uri.contains(RegExp(_CONTAINER_REGISTER_URI))) {
        String setCookie = response.headers.map[_SET_COOKIE_KEY].toString();
        saveCookie(setCookie);
      } else if (uri.contains(RegExp(_CONTAINER_LOGOUT_URI))) {
        clearCookie();
      }
    }
    handler.next(response);
  }

  void saveCookie(String cookie) {
    // this.cookie = cookie;
    // Preferences.save(_SAVE_TOKEN_KEY, cookie);
  }

  void clearCookie() {
    _cookie = "";
    //Preferences.remove(_SAVE_TOKEN_KEY);
  }
}
