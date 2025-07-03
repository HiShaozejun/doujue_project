import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:djqs/app/app_const.dart';
import 'package:djqs/app/app_icondata.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_file.dart';
import 'package:djqs/base/util/util_file_cache.dart';

class CameraUtil {
  //high为720p，20s时长android 33M ios18M，medium为480p,20s时长android 5M
  late final ResolutionPreset _currentResolutionPreset = ResolutionPreset.high;
  late final List<CameraDescription>? _cameras; //1前置0后置
  late final ImagePicker? _mediaPicker = ImagePicker();

  CameraController? _cameraController;

  State? _state;

  bool _isBackCamera = false; //后置摄像头
  bool _isInit = false;
  bool _isRecording = false;

  Timer? _timer;
  int _curTime = 0;
  double? _preHeight;
  double? _preWidth;
  double? _aspectRatio;

  CameraUtil() {}

  bool _isCameraInitialized = false;

  bool get isCameraInitialized => this._isCameraInitialized;

  bool _isCameraPermissionGranted = false;

  bool get isCameraPermissionGranted => this._isCameraPermissionGranted;

  double _cameraScale = 0;

  double get cameraScale => this._cameraScale;

  setState(state) {
    if (_state == null) _state = state;
  }

  void setPermissionAndInit() async {
    if (_isInit == true) return;
    _isInit = true;

    _cameras = await availableCameras();
    _state!.setState(() {
      _isCameraPermissionGranted = true;
    });
    await onNewCameraSelected(_cameras![0]);
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (_cameraController == null) return;

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    _cameraController!.setExposurePoint(offset);
    _cameraController!.setFocusPoint(offset);
  }

  /**
   * 录制相关
   */

  /**
   * 拍照相关
   */

  Future<XFile?> takePicture() async {
    if (_cameraController!.value.isTakingPicture) {
      return null;
    }
    try {
      XFile file = await _cameraController!.takePicture();
      return file;
    } on CameraException catch (e) {
      return null;
    }
  }

  /**
   * 周期相关
   */
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null) {
      return;
    }
    if (!_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(_cameraController!.description);
    }
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = _cameraController;
    if (oldController != null) {
      _cameraController = null;
      await oldController.dispose();
    }

    final CameraController newCameraController = CameraController(
      cameraDescription,
      _currentResolutionPreset,
      //imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _cameraController = newCameraController;

    _cameraController?.addListener(() {
      if (_state != null && _state!.mounted) {
        _state!.setState(() {});
      }

      if (_cameraController!.value.hasError) {
        BaseWidgetUtil.showToast(
            'Camera error ${_cameraController!.value.errorDescription}');
      }
    });

    try {
      await newCameraController.initialize();
    } on CameraException catch (e) {
      BaseWidgetUtil.showToast('Camera error ${e.code}\n${e.description}');
    } catch (e) {
      ///A CameraController was used after being disposed.Once you have called dispose() on a CameraController, it can no longer be used.
      e.toString();
    }

    if (_state != null && _state!.mounted) {
      _state!.setState(() {
        _isCameraInitialized = newCameraController!.value.isInitialized;
      });
    }
  }

  void onResume() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    await onNewCameraSelected(_cameraController!.description);
  }

  void onPause() async {}

  void dispose() async {
    try {
      _curTime = 0;
      _timer?.cancel();
      _isCameraInitialized = false;
      await _cameraController?.dispose();
    } catch (e) {}
  }

/*
    * 交互相关
    * */
  void btn_rotate() {
    _state?.setState(() {
      _isCameraInitialized = false;
    });
    onNewCameraSelected(_cameras![_isBackCamera ? 1 : 0]);
    _state!.setState(() {
      _isBackCamera = !_isBackCamera;
    });
  }

  double _getAspectRatio() {
    if (_aspectRatio == null)
      _aspectRatio = _cameraController!.value.aspectRatio;
    return _aspectRatio!;
  }

/*
    * ui相关
    * */
  Widget getCameraPreview(BuildContext context, {Widget? child}) {
    double width = 1.sw;
    return AspectRatio(
      aspectRatio: MediaQuery.of(context).size.aspectRatio,
      child: FittedBox(
        //it worked
        fit: BoxFit.fitHeight,
        child: Container(
          width: width,
          height: width * _getAspectRatio(),
          child: _cameraController == null
              ? Container()
              : CameraPreview(
                  _cameraController!,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (details) =>
                            onViewFinderTap(details, constraints),
                        child: Stack(children: [child ?? Container()])
                        // child: child,
                        );
                  }),
                ),
        ),
      ),
    );
  }

  Widget getActionBtnView(
      {String actionText = '',
      double? size = null,
      bool recording = false,
      bool prePage = false}) {
    size = (size == null ? 70.r : size);
    double borderWidth = 5.w;
    double indicatorWidth = 4.w;
    double innerSize = size - borderWidth * 2;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: 0,
            backgroundColor: BaseColors.ffffff,
            valueColor: new AlwaysStoppedAnimation<Color>(BaseColors.c00a0e7),
            strokeWidth: indicatorWidth,
          ),
        ),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
            border: Border.fromBorderSide(
                BorderSide(color: BaseColors.trans, width: borderWidth)),
          ),
          child: Container(
            width: innerSize,
            height: innerSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(innerSize / 2),
              color: BaseColors.e70012,
            ),
            alignment: Alignment.center,
            child: prePage
                ? Container()
                : Text(
                    _isRecording ? "结束\n$actionText" : "$actionText",
                    style: TextStyle(fontSize: 15.sp, color: BaseColors.ffffff),
                  ),
          ),
        ),
      ],
    );
  }

  Widget getCameraBottomView(
          {String? actionText,
          Function()? onBack,
          Function()? onPickMedia,
          Function()? onAction,
          Function()? onRotate}) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isRecording)
              BaseWidgetUtil.getTextWithIconV("退出$actionText",
                  icon: Icons.exit_to_app, onTap: onBack),
            if (!_isRecording)
              Spacer(
                flex: 3,
              ),
            Column(
              children: [
                if (_isRecording)
                  Text(
                    _curTime == 0 ? '' : _curTime.toString() + "秒",
                    style: TextStyle(
                        color: BaseColors.ffffff,
                        fontWeight: BaseDimens.fw_l,
                        fontSize: 12.sp),
                  ),
                if (_isRecording) BaseGaps().vGap10,
                InkWell(
                  onTap: onAction,
                  child: getActionBtnView(
                      actionText: actionText ?? '', recording: _isRecording),
                ),
              ],
            ),
            if (!_isRecording)
              Spacer(
                flex: 5,
              ),
          ],
        ),
      );
}
