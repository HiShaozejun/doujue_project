import 'dart:convert';

import 'package:djqs/app/app_const.dart';
import 'package:djqs/base/entity/clipborard_entity.dart';
import 'package:djqs/base/ui/base_dialog.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/common/util/common_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseClipboardUtil {
  bool _isShown = false;

  BaseClipboardUtil._internal();

  factory BaseClipboardUtil() => _instance;

  static late final BaseClipboardUtil _instance = BaseClipboardUtil._internal();

  void dealWithClipboard(BuildContext context, {bool showDiloag = false}) {
    if (CommonUtil().isFirstLogin) return;
    if (!_isShown) {
      _isShown = true;
      Future.delayed(Duration(milliseconds: 100))
          .then((value) => getClipboard(callback: (String str) async {
                await clearClipboard();
                showDiloag
                    ? _showDialog(context, str)
                    : dealWithContent(context, str);
              }));
    }
  }

  void getClipboard({Function(String str)? callback}) async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (!ObjectUtil.isEmptyStr(data?.text)) callback?.call(data!.text!);
  }

  Future setClipboard(String str) async =>
      await Clipboard.setData(ClipboardData(text: str));

  Future clearClipboard() async {
    await Clipboard.setData(ClipboardData(text: ''));
  }

  bool get isShown => _isShown;

  void set isShown(bool value) => _isShown = value;

  void _showDialog(BuildContext context, String str) {
    _isShown = false;
    BaseDialogUtil.showCommonDialog(context,
        title: '提示',
        content: "分享",
        onPosBtn: () => dealWithContent(context, str));
  }

  void dealWithContent(BuildContext context, String str) {
    try {
      String jsonStr = Uri.decodeComponent(str);
      ClipboardEntity? entity = ClipboardEntity.fromJson(jsonDecode(jsonStr));
      if (entity?.packageName != AppConst.APP_ANDROID_PACKAGENAME &&
          entity?.packageName != AppConst.APP_IOS_BUNDLE_ID) return;

      if (ObjectUtil.isEmpty(entity?.mediaId)) {
        // TTPlayBundleData bundle = TTPlayBundleData();
        // bundle.mediaID = entity.mediaId;
        // bundle.sourceType = TTPlayBundleData.SOURCE_TYPE_SEARCH;
        // bundle.enableHead = false;
        // bundle.enableSearch = false;
        // BaseRouteUtil.push(null, TTPlayPage(ttBundle: bundle));
      }
    } catch (e) {
      e.toString();
    }
  }
}
