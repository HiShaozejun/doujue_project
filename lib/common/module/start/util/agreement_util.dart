import 'package:djqs/app/app_const.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/route/base_util_route.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/common/module/start/util/app_init_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AgreementUtil {
  Function()? onNagBtn;
  Function()? onPosBtn;

  final BuildContext _context;

  AgreementUtil(this._context, {this.onPosBtn, this.onNagBtn});

  late final TapGestureRecognizer tapRecognizer1 = TapGestureRecognizer()
    ..onTap = _handlePress1;
  late final TapGestureRecognizer tapRecognizer2 = TapGestureRecognizer()
    ..onTap = _handlePress2;

  _handlePress1() => BaseRouteUtil.pushH5(_context,
      url: AppConst().H5_AGREEMENT, title: '用户协议');

  _handlePress2() =>
      BaseRouteUtil.pushH5(_context, url: AppConst().H5_PRIVACY, title: '隐私协议');

  void showAgreeDialog({bool isSimple = false}) => showDialog<void>(
      context: _context,
      barrierColor: isSimple == true
          ? BaseColors.c161616.withOpacity(0.5)
          : BaseUIUtil().getTheme().primaryColor,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => onPosBtn == null ? true : false,
          child: _getAlert(isSimple: isSimple, context: context)));

  Widget _getAlert({bool isSimple = false, BuildContext? context}) =>
      AlertDialog(
          title: Text(
              textAlign: TextAlign.center,
              '用户协议与隐私政策',
              style: BaseUIUtil().getTheme().primaryTextTheme.displayLarge),
          content: isSimple == true
              ? _smallDialogView(context ?? AppInitUtil().curContext!)
              : _bigDialogView(context ?? AppInitUtil().curContext!));

  Widget _bigDialogView(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              '(1)《隐私政策》中关于个人设备用户信息的收集和使用的说明。\n(2)《隐私政策》中与第三方SDK类服务商数据共享、相关信息收集和使用说明。'
              '\n用户协议和隐私政策说明：',
              style: TextStyle(
                  fontSize: 13.sp,
                  color: BaseUIUtil()
                      .getTheme()
                      .primaryTextTheme
                      .titleSmall!
                      .color,
                  height: 1.5)),
          RichText(
              softWrap: true,
              text: TextSpan(children: [
                TextSpan(
                    text: '可阅读完整的',
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: BaseUIUtil()
                            .getTheme()
                            .primaryTextTheme
                            .titleSmall!
                            .color)),
                TextSpan(
                    recognizer: tapRecognizer1,
                    text: '《用户服务协议》',
                    style:
                        TextStyle(fontSize: 13.sp, color: BaseColors.c2872fc)),
                TextSpan(
                    text: '和',
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: BaseUIUtil()
                            .getTheme()
                            .primaryTextTheme
                            .titleSmall!
                            .color)),
                TextSpan(
                  recognizer: tapRecognizer2,
                  text: '《隐私政策》',
                  style: TextStyle(fontSize: 13.sp, color: BaseColors.c2872fc),
                ),
                TextSpan(
                  text: '了解详细内容。',
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: BaseUIUtil()
                          .getTheme()
                          .primaryTextTheme
                          .titleSmall!
                          .color),
                )
              ])),
          SizedBox(height: 20),
          BaseWidgetUtil.getBottomButton(
              includeBottomMargin: false,
              marginH: 20.w,
              '同意并继续',
              backgroudColor: BaseColors.c2872fc, onPressed: () {
            Navigator.pop(context);
            onPosBtn?.call();
          }),
          SizedBox(height: 10),
          BaseWidgetUtil.getBottomButton(
              includeBottomMargin: false,
              '不同意并退出APP',
              onPressed: onNagBtn,
              textColor: BaseColors.c747474,
              fontWeight: BaseDimens.fw_m,
              height: 35.h,
              marginH: 20.w,
              backgroudColor: BaseColors.dad8d8)
        ],
      );

  Widget _smallDialogView(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              softWrap: true,
              text: TextSpan(children: [
                TextSpan(
                    text: '为保障您的合法权益，请阅读并同意',
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: BaseUIUtil()
                            .getTheme()
                            .primaryTextTheme
                            .titleSmall!
                            .color)),
                TextSpan(
                  recognizer: tapRecognizer1,
                  text: '《用户服务协议》',
                  style: TextStyle(fontSize: 13.sp, color: BaseColors.c2872fc),
                ),
                TextSpan(
                  text: '和',
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: BaseUIUtil()
                          .getTheme()
                          .primaryTextTheme
                          .titleSmall!
                          .color),
                ),
                TextSpan(
                    recognizer: tapRecognizer2,
                    text: '《隐私政策》',
                    style:
                        TextStyle(fontSize: 13.sp, color: BaseColors.c2872fc))
              ])),
          SizedBox(height: 5),
          Text('顺单侠将严格保护您的个人信息安全',
              style: TextStyle(
                  fontSize: 13.sp,
                  color: BaseUIUtil()
                      .getTheme()
                      .primaryTextTheme
                      .displaySmall!
                      .color,
                  fontWeight: BaseDimens.fw_l,
                  height: 1.5)),
          SizedBox(height: 30),
          BaseWidgetUtil.getBottomButton(
              includeBottomMargin: false, marginH: 5.h, '同意并登录', onPressed: () {
            Navigator.pop(context);
            onPosBtn?.call();
          }),
          SizedBox(height: 15),
          InkWell(
              onTap: () {
                Navigator.pop(context);
                onNagBtn?.call();
              },
              child: Center(
                  child: Text('不同意',
                      style:
                          BaseUIUtil().getTheme().primaryTextTheme.bodyMedium)))
        ],
      );
}
