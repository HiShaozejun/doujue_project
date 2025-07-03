import 'package:djqs/app/app_const.dart';
import 'package:djqs/app/netDuo/base_service_duo.dart';
import 'package:djqs/base/const/base_const.dart';
import 'package:djqs/base/entity/base_update_entity.dart';
import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/ui/base_dialog.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';
import 'package:upgrader/upgrader.dart';

import 'util_system.dart';

class BaseUpgradeUtil {
  late final UpdateService _service = UpdateService();
  late final BaseSystemUtil _systemUtil = BaseSystemUtil();

  bool _isShownDialog = false;
  bool _isLoading = false;

  BaseUpgradeEntity? _entity;

  BaseUpgradeUtil._internal();

  factory BaseUpgradeUtil() => _instance;

  static late final BaseUpgradeUtil _instance = BaseUpgradeUtil._internal();

  Widget getUpgradeView({Widget? child}) {
    if (_isShownDialog) return child!;
    _isShownDialog = true;
    if (BaseSystemUtil().isIOS)
      return UpgradeAlert(child: child);
    else
      return child!;
  }

  void check({bool newedShow = false}) async {
    if (BaseSystemUtil().isIOS && newedShow) {
      BaseSystemUtil()
          .launchLink('${BaseConst.IOS_STORE_LINK}+id${AppConst.IOS_APP_ID}');
    }
    if (BaseSystemUtil().isAndroid) {
      _entity = await _service.getUpgradeData();

      if (_entity == null) {
        if (newedShow) BaseWidgetUtil.showToast("无更新");
        return;
      }

      if (_systemUtil.versionCode >= (_entity?.serverVersion ?? 0)) {
        if (newedShow) BaseWidgetUtil.showToast("已是最新版本");
        return;
      }

      if (_entity?.upgradeType == BaseUpgradeEntity.UPGRADE_TYPE_NO) {
        if (newedShow) BaseWidgetUtil.showToast("无更新");
        return;
      }

      BaseDialogUtil.showCommonDialog(null,
          isPopDialog: _entity?.isForceUpdate ? false : true,
          title:
              ObjectUtil.isEmptyStr(_entity?.title) ? "版本更新" : _entity?.title,
          content: ObjectUtil.isEmptyStr(_entity?.newFeature)
              ? "app有新版本了，是否更新"
              : _entity?.newFeature,
          leftBtnStr: _entity?.isForceUpdate ? "退出应用" : '取消',
          rightBtnStr: '更新',
          onNagBtn: () {
            if (_entity?.isForceUpdate) _systemUtil.exitApp();
          },
          onPosBtn: () => _isLoading == true
              ? {BaseWidgetUtil.showToast('正在更新中，请耐心等待')}
              : _dealWithUpgrade());
    }
  }

  void _dealWithUpgrade() {
    if (ObjectUtil.isEmptyStr(_entity?.appUrl)) {
      BaseWidgetUtil.showToast("更新地址出错");
      return;
    }
    if (_systemUtil.isIOS) {
      _systemUtil.launchLink(_entity!.appUrl!);
    } else if (_systemUtil.isAndroid) {
      _otaUpdate();
    }
  }

  void _otaUpdate() {
    bool showLoading = false;
    bool showInstalling = false;
    bool showError = false;
    try {
      OtaUpdate()
          .execute(_entity!.appUrl!,
              destinationFilename: 'sdx_app.apk',
              sha256checksum: _entity!.sha256)
          .listen(
        (OtaEvent event) {
          switch (event.status) {
            case OtaStatus.DOWNLOADING:
              if (!showLoading) {
                _isLoading = true;
                BaseWidgetUtil.showToast('开始下载安装包..请稍稍等待，不要退出应用');
                showLoading = true;
              }
              // if (_entity?.isForceUpdate) _systemUtil.exitApp();
              break;
            case OtaStatus.INSTALLING:
              _isLoading = false;
              if (!showInstalling) {
                BaseWidgetUtil.showToast('准备安装');
                showInstalling = true;
              }
              break;
            default:
              if (!showError) {
                _isLoading = false;
                BaseWidgetUtil.showToast('更新出错');
                showError = true;
              }
              break;
          }
        },
      );
    } catch (e) {
      _isLoading = false;
      BaseWidgetUtil.showToast("应用下载失败，更新失败");
    }
  }
}

class UpdateService extends BaseServiceDuo {
  Future<BaseUpgradeEntity?> getUpgradeData() => requestSync(
      showLoading: false,
      data: {'platform': BaseSystemUtil().platform},
      path: "${BaseNetConst().commonUrl}Rider.Version.Index",
      create: (resource) => BaseUpgradeEntity.fromJson(resource));
}
