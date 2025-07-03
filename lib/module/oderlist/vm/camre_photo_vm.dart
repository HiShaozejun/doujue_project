import 'dart:io';
import 'dart:ui' as ui;
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'package:camera/camera.dart';
import 'package:djqs/base/ui/base_dialog.dart';
import 'package:djqs/module/oderlist/entity/watermark_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_ffvideo.dart';
import 'package:djqs/base/util/util_file.dart';
import 'package:djqs/base/util/util_image.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/common/util/common_util_upload.dart';
import 'package:path_provider/path_provider.dart';

class CameraPhotoVM extends BaseNotifier {
  WatermarkData? markData;

  CameraPhotoVM(super.context, this.markData);

  @override
  void init() async {}

  void btn_begin(XFile? photo, GlobalKey key) async {
    if (photo == null) {
      toast('拍照出错，请重新拍摄');
      _reset();
      return;
    }

    BaseWidgetUtil.showLoading(text: '水印生成中..');
    markData!.imgPath = photo.path;
    markData!.markPath = await BaseImageUtil().drawMark(
        markData!.imgPath!,
        markStr,
        TextStyle(
            color: BaseColors.ffffff,
            fontSize: 25,
            height: 1.5,
            fontWeight: BaseDimens.fw_l_x),
        ui.Offset(30, 140));

    BaseWidgetUtil.cancelLoading();
    if (ObjectUtil.isEmptyStr(markData!.markPath)) {
      toast('拍照出错，请重新拍摄');
      _reset();
      return;
    }
    BaseDialogUtil.showCommonDialog(baseContext,
        title: '预览',
        leftBtnStr: '重新拍摄',
        rightBtnStr: '确定',
        onNagBtn: _reset,
        onPosBtn: () => _dealWithPhotoData(callback: dealWithBack),
        contentWidget: Image.file(File(markData!.markPath!),
            height: 220.w * 1.sh / 1.sw, width: 250.w, fit: BoxFit.fill));
  }

  String get markStr =>
      '时间：${markData?.date ?? ''}\n经纬度: ${markData?.locationData?.lat ?? ''}, ${markData?.locationData?.lng ?? ''}\n位置: ${markData?.locationData?.address ?? ''}';

  void dealWithBack(String? url) {
    // if (ObjectUtil.isEmptyStr(url)) {
    //   toast('拍照出错，请重新拍摄');
    //   _reset();
    // } else
    //   pagePop(params: url);
    //to-do
    pagePop(params: url);
  }

  void _dealWithPhotoData({Function(String? url)? callback}) async {
    // XFile? compressFile =
    //     await BaseImageUtil().compressImage(markData!.markPath!);
    BaseFileUtil().deleteFilePath(markData!.imgPath!);
    BaseWidgetUtil.showLoading(dismissOnTap: false, text: '图片上传中，请稍后..');
    CommonUploadUtil().uploadToCos(markData!.markPath!, showLoading: false,
        callback: (String? url) {
      BaseFileUtil().deleteFilePath(markData!.markPath!);
      BaseWidgetUtil.cancelLoading();
      callback?.call(url);
    });
  }

  void _reset() {
    markData?.imgPath = null;
    markData?.markPath = null;
    notifyListeners();
  }

  @override
  void onCleared() {
    // TODO: implement onCleared
  }
}
