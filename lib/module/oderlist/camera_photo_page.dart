import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/module/oderlist/entity/watermark_data.dart';
import 'package:djqs/module/oderlist/util/camera_util.dart';
import 'package:djqs/module/oderlist/vm/camre_photo_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:djqs/base/frame/base_pagestate.dart';

class CameraPhotoPage extends StatefulWidget {
  WatermarkData? markData;

  CameraPhotoPage({super.key, required this.markData});

  @override
  _CameraPhototate createState() => _CameraPhototate();
}

class _CameraPhototate extends BasePageState<CameraPhotoPage, CameraPhotoVM> {
  final GlobalKey _key = GlobalKey();
  late final CameraUtil _cameraUtil = CameraUtil();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _cameraUtil.didChangeAppLifecycleState(state);
  }

  @override
  void onResume() {
    super.onResume();
    _cameraUtil.onResume();
  }

  @override
  void dispose() {
    _cameraUtil.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) _cameraUtil.setState(this);
    return buildViewModel<CameraPhotoVM>(
        create: (context) => CameraPhotoVM(context, widget.markData),
        viewBuild: (context, vm) {
          _cameraUtil.setPermissionAndInit();
          return _cameraUtil.isCameraPermissionGranted
              ? _cameraUtil.isCameraInitialized
                  ? Stack(fit: StackFit.expand, children: [
                      _cameraUtil.getCameraPreview(context,
                          child: RepaintBoundary(
                              key: _key,
                              child: Stack(
                                children: [
                                  Positioned(
                                      bottom: 80.h,
                                      left: 30.w,
                                      child: _overlayView()),
                                ],
                              ))),
                      Positioned(
                        width: 1.sw,
                        bottom: 0,
                        child: _cameraUtil.getCameraBottomView(
                            actionText: '拍照',
                            onBack: vm.pagePop,
                            onAction: () async => vm.btn_begin(
                                await _cameraUtil.takePicture(), _key)),

                      ),
                    ])
                  : Center(child: CircularProgressIndicator())
              : Center(child: CircularProgressIndicator());
        });
  }

  Widget _overlayView() => BaseWidgetUtil.getContainer(
      paddingH: 10.w,
      paddingV: 5.h,
      color: BaseColors.trans,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _textView('时间：${vm.markData?.date ?? ''}'),
        _textView(
            '经纬度: ${vm.markData?.locationData?.lat ?? ''}, ${vm.markData?.locationData?.lng ?? ''}'),
        _textView('位置: ${vm.markData?.locationData?.address ?? ''}')
      ]));

  Widget _textView(String text) => Text(text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 14.sp,
          fontWeight: BaseDimens.fw_l,
          color: BaseColors.ffffff,
          shadows: BaseWidgetUtil.getShadow()));
}
