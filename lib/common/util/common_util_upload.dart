import 'dart:convert';

import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/net/base_service.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_debug.dart';
import 'package:djqs/base/util/util_file.dart';
import 'package:djqs/base/util/util_log.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:djqs/common/entity/tx_cossign_entity.dart';
import 'package:djqs/common/entity/tx_vodsign_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:tencentcloud_cos_sdk_plugin/cos.dart';
import 'package:tencentcloud_cos_sdk_plugin/cos_transfer_manger.dart';
import 'package:tencentcloud_cos_sdk_plugin/fetch_credentials.dart';
import 'package:tencentcloud_cos_sdk_plugin/pigeon.dart';

class CommonUploadUtil {
  final Cos _cosUtil = Cos();
  late CosTransferManger? _cosTransUtil;
  Function(String? url)? cosCallback;

  //
  final TCService _service = TCService();
  TXCosSignEntity? _cosEntity;

  CommonUploadUtil._internal();

  factory CommonUploadUtil() => _instance;

  static late final CommonUploadUtil _instance = CommonUploadUtil._internal();

  Future init() async {
    try {
      await _cosUtil.enableLogcat(true);
      await _cosUtil.enableLogFile(true);
      await _cosUtil.setMinLevel(LogLevel.verbose);
      await _cosUtil
          .setAppVersion(BaseSystemUtil().versionCode.toString() ?? '0');
      await _cosUtil.addLogListener((LogEntity entity) {
        print(entity.message);
      });
    } catch (e) {
      e.toString();
    }
    _resetCos(isInit: true);
  }

  Future<void> _resetCos({bool isInit = true}) async {
    dynamic baseEntity = await _service.getCosSign(showLoading: false);
    _cosEntity = TXCosSignEntity.fromJson(baseEntity?.result);
    if (isInit) {
      await _cosUtil?.initWithSessionCredential(FetchCredentials());
    }
    CosXmlServiceConfig _serviceConfig = CosXmlServiceConfig(
        region: _cosEntity?.region,
        isDebuggable: BaseDebugUtil().isDebug(),
        isHttps: true);
    await _cosUtil?.registerDefaultService(_serviceConfig);
    _cosTransUtil = await _cosUtil?.registerDefaultTransferManger(
        _serviceConfig, TransferConfig());
  }

  void uploadToCos(String? path,
      {bool showLoading = true,
      Function(String? url)? callback,
      bool recurse = true}) async {
    if (_cosEntity != null && _cosEntity?.credentials != null) {
      BaseLogUtil().d('签名数据信息 -- ${jsonEncode(_cosEntity)}');
      await _cosTransUtil?.upload(_cosEntity!.bucket!,
          BaseFileUtil().getFileName(path, includeSuffix: true)!,
          filePath: path,
          uploadId: null,
          resultListener: ResultListener(
              (Map<String?, String?>? header, CosXmlResult? result) {
            if (header != null)
              callback?.call(header['accessUrl']);
            else
              callback?.call(null);
          }, (CosXmlClientException? clientException,
                  CosXmlServiceException? serviceException) async {
            if(clientException != null) {
              final clientExc = jsonEncode(clientException.encode());
              BaseLogUtil().d('CosXmlClientException失败异常信息 --- $clientExc');
            }
            if(serviceException != null) {
              final serviceExc = jsonEncode(serviceException.encode());
              BaseLogUtil().d('CosXmlServiceException失败异常信息 --- $serviceExc');
            }

            if (recurse) {
              await _resetCos(isInit: false);
              uploadToCos(path,
                  showLoading: showLoading, callback: callback, recurse: false);
            }

          }));
    } else {
      if (recurse) {
        await _resetCos(isInit: false);
        uploadToCos(path,
            showLoading: showLoading, callback: callback, recurse: false);
      }
    }
  }
}

class FetchCredentials implements IFetchCredentials {
  final TCService _service = TCService();

  static Future<SessionQCloudCredentials?> getSessionCredentials() async {
    FetchCredentials fetchCredentials = FetchCredentials();
    return await fetchCredentials.fetchSessionCredentials();
  }

  @override
  Future<SessionQCloudCredentials> fetchSessionCredentials() async {
    try {
      dynamic baseEntity = await _service.getCosSign(showLoading: false);
      TXCosSignEntity? cosEntity = TXCosSignEntity.fromJson(baseEntity?.result);

      SessionQCloudCredentials credentialData = SessionQCloudCredentials(
          secretId: cosEntity?.credentials?.tmpSecretId ?? '',
          secretKey: cosEntity?.credentials?.tmpSecretKey ?? '',
          token: cosEntity?.credentials?.sessionToken ?? '',
          expiredTime: cosEntity?.expiredTime ?? 0);
      return credentialData;
    } catch (exception) {
      BaseWidgetUtil.showToast('图片上传session初始化出错');
      throw ArgumentError();
    }
  }
}

class TCService extends BaseService {
  //return Map<String,dynamic>
  Future<dynamic> getCosSign({bool showLoading = true}) => requestSync(
      isBaseResult: true,
      returnBaseEntity: true,
      data: {'region': ''},
      path: "${BaseNetConst().djCommonUrl}/cos/get-tmp-sign",
      create: (resource) => resource,
      showLoading: showLoading);

  Future<TXVodSignEntity?> getVodSign({bool showLoading = true}) {
    return requestSync(
        data: {"cate": 'vod'},
        path: "${BaseNetConst().djCommonUrl}/vod/get-sign",
        create: (resource) => TXVodSignEntity.fromJson(resource),
        showLoading: showLoading);
  }
}
