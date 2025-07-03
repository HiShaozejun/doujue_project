import 'package:dio/dio.dart';
import 'package:djqs/base/net/base_dio_util.dart';
import 'package:djqs/base/net/base_entity.dart';
import 'package:djqs/base/net/base_net_const.dart';

abstract class BaseService {
  late Dio _dio;

  /// 子类如需替换域名地址可以在构造函数中创建新的dio替换
  ///   ChildModel() {
  ///     super.dio = HttpManager.createDio(baseUri);
  ///   }
  BaseService({Dio? dio}) {
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
        bool isBaseResult = false,
      String? headerMenuUrl,
      String? headerMenuCode}) async {
    dynamic result = await BaseDioUtil().request<T>(
        path: path,
        create: create,
        queryParameters: queryParameters,
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        method: method,
        isBaseEntity: isBaseEntity,
        isBaseResult:isBaseResult,
        returnBaseEntity: returnBaseEntity,
        showLoading: showLoading,
        headerMenuCode: headerMenuCode,
        headerMenuUrl: headerMenuUrl);
    if (result is BaseEntity && result.ret == BaseNetConst.REQUEST_AGAIN)
      result = await BaseDioUtil().request<T>(
          path: path,
          create: create,
          queryParameters: queryParameters,
          data: data,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          method: method,
          isBaseEntity: isBaseEntity,
          isBaseResult:isBaseResult,
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
      BaseDioUtil().request(
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

  void dispose() => BaseDioUtil().dispose();
}
