import 'package:dio/dio.dart';
import 'package:djqs/app/netDuo/base_dio_util_duo.dart';
import 'package:djqs/base/net/base_entity.dart';
import 'package:djqs/base/net/base_net_const.dart';

abstract class BaseServiceDuo {
  late Dio _dio;

  BaseServiceDuo({Dio? dio}) {
    if (dio != null) this._dio = dio; //todo 扩展
  }

  Future<T> requestSync<T>(
      {required String path,
      required CreateEntity<T>
          create, //required T Function(dynamic resource) create,
      Map<String, dynamic>? queryParameters,
      Object? data,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      String? method = BaseNetConst.REQUEST_POST,
      bool returnBaseEntity = false,
      bool showLoading = true,
      bool isBaseEntity = true,
      String? headerMenuUrl,
      String? headerMenuCode}) async {
    dynamic result = await BaseDioUtilDuo().request<T>(
        path: path,
        create: create,
        queryParameters: queryParameters,
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        method: method,
        isBaseEntity: isBaseEntity,
        returnBaseEntity: returnBaseEntity,
        showLoading: showLoading,
        headerMenuCode: headerMenuCode,
        headerMenuUrl: headerMenuUrl);
    if (result is BaseEntity && result.ret == BaseNetConst.REQUEST_AGAIN)
      result = await BaseDioUtilDuo().request<T>(
          path: path,
          create: create,
          queryParameters: queryParameters,
          data: data,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          method: method,
          isBaseEntity: isBaseEntity,
          returnBaseEntity: returnBaseEntity,
          showLoading: showLoading,
          headerMenuCode: headerMenuCode,
          headerMenuUrl: headerMenuUrl);

    return result;
  }

  request<T>(
          {required String path,
          required CreateEntity<T>
              create, //required T Function(dynamic resource) create,
          Map<String, dynamic>? queryParameters,
          Object? data,
          CancelToken? cancelToken,
          ProgressCallback? onReceiveProgress,
          String? method = BaseNetConst.REQUEST_POST,
          bool returnBaseEntity = false,
          bool showLoading = true,
          bool isBaseEntity = true,
          String? headerMenuUrl,
          String? headerMenuCode}) =>
      BaseDioUtilDuo().request(
          path: path,
          create: create,
          queryParameters: queryParameters,
          data: data,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          method: method,
          isBaseEntity: isBaseEntity,
          returnBaseEntity: returnBaseEntity,
          showLoading: showLoading,
          headerMenuCode: headerMenuCode,
          headerMenuUrl: headerMenuUrl);

  void dispose() => BaseDioUtilDuo().dispose();
}
