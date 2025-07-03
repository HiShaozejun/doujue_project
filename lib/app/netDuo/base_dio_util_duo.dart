import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:djqs/app/netDuo/base_entity_duo.dart';
import 'package:djqs/base/net/base_interceptor_exception.dart';
import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_location.dart';
import 'package:djqs/base/util/util_log.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:djqs/common/module/login/util/util_account.dart';

class BaseDioUtilDuo {
  late Dio _dio;
  CancelToken cancelToken = CancelToken();
  bool isRefreshToken = false;

  BaseDioUtilDuo._internal() {
    _dio = createDio(BaseNetConst().commonUrl);
  }

  factory BaseDioUtilDuo() => _instance;

  static late final BaseDioUtilDuo _instance = BaseDioUtilDuo._internal();

  Dio createDio(String baseUri) {
    BaseOptions options = new BaseOptions(
      sendTimeout: Duration(seconds: BaseNetConst.DIO_TIMEOUT),
      connectTimeout: Duration(seconds: BaseNetConst.DIO_TIMEOUT),
      receiveTimeout: Duration(seconds: BaseNetConst.DIO_TIMEOUT),
    );
    Dio dio = new Dio(options);

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.findProxy = (uri) {
          return 'DIRECT';
        };
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) {
        log(obj.toString());
      },
    ));
    //dio.interceptors.add(BaseCookieInterceptor());
    dio.interceptors.add(BaseExceptionInterceptor());
    return dio;
  }

  //return  Future<Object?> not Future<T?>
  // 因为不支持泛型，该T对map无效,此时属于回调解析确认T的类型，所以无需传入T类型，其他基数数据则需明示T类型,
  //but因为在实际service调用时，明示了返回类型，如Future<AccountEntity?>，so实际T类型已确定，可以偷懒不再在方法后传入
  request<T>(
      {required String path,
      CreateEntity<T>? create, //required T Function(dynamic resource) create,
      Map<String, dynamic>? queryParameters,
      Object? data,
      Map<String, dynamic>? header,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      String? method = BaseNetConst.REQUEST_POST,
      bool returnBaseEntity = false,
      bool isBaseEntity = true,
      bool showLoading = true,
      bool showFunMsg = true,
      String? headerMenuUrl,
      String? headerMenuCode}) async {
    if (showLoading) {
      await BaseWidgetUtil.showLoading();
    }

    Map baseData = {
      Headers.contentTypeHeader: Headers.jsonContentType,
      //Headers.acceptHeader: Headers.jsonContentType,
      //Headers.acceptHeader: 'utf-8', // set the character encoding to utf-8
      'token': AccountUtil().getAccount()?.token ?? '',
      'uid': AccountUtil().getAccount()?.id ?? '',
      'cityid': AccountUtil().getAccount()?.cityid ?? '',
      'lat':
          Uri.encodeComponent(BaseLocationUtil().getLocationData()?.lat ?? ''),
      'lng':
          Uri.encodeComponent(BaseLocationUtil().getLocationData()?.lng ?? ''),
      'source': BaseSystemUtil().platformCode,
      "version": BaseSystemUtil().versionName,
      "lang": "zh",
    };
    Options options = new Options(
        method: method,
        headers: header); // headers: header == null ? baseData : header

    if (data is Map) baseData?.addAll(data);
    Response? response;
    if (method == BaseNetConst.REQUEST_GET)
      response = await _dio.get(path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken ?? cancelToken,
          onReceiveProgress: onReceiveProgress);
    if (method == BaseNetConst.REQUEST_POST)
      response = await _dio.post(path,
          data: baseData,
          options: options,
          cancelToken: cancelToken ?? cancelToken,
          onReceiveProgress: onReceiveProgress);

    if (response?.statusCode == 200) {
      //
      if (showLoading) await BaseWidgetUtil.cancelLoading();
      //
      if (!isBaseEntity) return response;
      //
      try {
        BaseEntityDuo baseEntity = BaseEntityDuo<T>.fromJson(response?.data);
        //
        if (baseEntity.ret == BaseNetConst.REQUEST_OK) {
          if (returnBaseEntity) return baseEntity.data as T;
          await _dealWithFunError(baseEntity.data, showFunMsg);
          T entity = create!(baseEntity.data?.info);
          return entity;
        } else if (baseEntity.ret! >= 4000 && baseEntity.ret! <= 4999) {
          _dealWithError(baseEntity.msg);
        }  else
          _dealWithError(baseEntity.msg);
      } catch (e) {
        BaseLogUtil().e(e.toString());
        //_dealWithError('网络数据错误');
      }
    } else {
      _dealWithError('网络请求错误');
    }
  }

  _dealWithFunError(FuncEntityDuo? entity, showFunMsg) async {
    if (entity?.code == BaseNetConst.REQUEST_LOGIN_EXPIRED) {
      if (!AccountUtil().isLogouting) {
        BaseWidgetUtil.showToast(entity?.msg ?? "");
        await AccountUtil().logout();
      }
    } else if (entity?.code != BaseNetConst.REQUEST_APP_OK &&
        showFunMsg == true) BaseWidgetUtil.showToast(entity?.msg ?? "");
  }

  void _dealWithError(String? str) {
    //return null;
    isRefreshToken = false;
    BaseWidgetUtil.showToast(str ?? '网络数据错误');
  }

  Future<void> refreshTokenSync(
      {bool? needReqAgain, BaseEntityDuo? preResult}) async {
    if (isRefreshToken == false) {
      isRefreshToken = true;
      // await _refreshToken(needReqAgain: needReqAgain, preResult: preResult);
      //to-do
      AccountUtil().hasLogined(
          isCanBack: false,
          callback: () async {
            preResult?.ret = BaseNetConst.REQUEST_AGAIN;
          });
    }
  }

// Future<void> _refreshToken(
//     {bool? needReqAgain, BaseEntity? preResult}) async {
//   dynamic resource = await _requestrefreshToken('',
//       //AccountUtil().getAccount()?.refreshToken,
//       AccountUtil().getAccount()?.token);
//   if (resource == null) {
//     isRefreshToken = false;
//     return;
//   }
//
//   try {
//     RefreshTokenEntity? tokenEntity = RefreshTokenEntity.fromJson(resource);
//     AccountEntity? accountEntity = AccountUtil().getAccount();
//     accountEntity?.token = tokenEntity.token;
//     //accountEntity?.refreshToken = tokenEntity.refreshToken;
//     await AccountUtil().setAccount(accountEntity);
//     isRefreshToken = false;
//     if (needReqAgain == true) preResult?.ret = BaseNetConst.REQUEST_AGAIN;
//   } catch (e) {
//     isRefreshToken = false;
//     BaseLogUtil().e(e.toString());
//   }
// }
//
// Future<dynamic> _requestrefreshToken(
//         String? refresh_token, String? token) async =>
//     request(
//         data: {'refresh_token': refresh_token, 'token': token},
//         path: "${BaseNetConst().passportUrl}/token/userc/refresh",
//         create: (resource) => resource);
//
  void dispose() {
    cancelToken.cancel("取消请求");
  }
}

typedef CreateEntity<T> = T Function(dynamic resource);

typedef OnFail = Function(dynamic msg);
