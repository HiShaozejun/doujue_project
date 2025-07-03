import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/res/base_icons.dart';
import 'package:djqs/base/route/base_util_route.dart';
import 'package:djqs/base/util/util_image.dart';
import 'package:djqs/common/module/start/util/app_init_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'base_ui_util.dart';

enum ItemType { NONE, TEXT, IMG, SWITCH, WIDGET }

class BaseWidgetUtil {
  static void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskType = EasyLoadingMaskType.clear
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = BaseColors.c00a0e7
      ..backgroundColor = BaseColors.c00a0e7.withOpacity(0.3)
      ..indicatorColor = BaseColors.c66dca0
      ..textColor = BaseColors.ffffff
      ..userInteractions = false
      ..dismissOnTap = true;
  }

  static Future<void> showLoading(
      {bool dismissOnTap = true, String? text}) async {
    if (EasyLoading.isShow) return;
    await EasyLoading.show(dismissOnTap: dismissOnTap, status: text);
  }

  static Future<void> showProgress(double progress, {String? value}) async {
    await EasyLoading.showProgress(progress, status: value);
  }

  static Future<void> cancelLoading() async => await EasyLoading.dismiss();

  static Future<bool?> showToast(String str,
          {Color bgColor = BaseColors.c828282,
          Color textColor = BaseColors.ffffff,
          ToastGravity gravity = ToastGravity.BOTTOM}) =>
      Fluttertoast.showToast(
          msg: str,
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 14.sp,
          backgroundColor: bgColor,
          gravity: gravity,
          textColor: textColor);

  static Future<bool?> showErrorToast(String str,
          {Color bgColor = BaseColors.ffffff,
          Color textColor = BaseColors.e70012,
          ToastGravity gravity = ToastGravity.BOTTOM}) =>
      Fluttertoast.showToast(
          msg: str,
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 16.sp,
          backgroundColor: bgColor,
          gravity: gravity,
          textColor: textColor);

  void showSnackbar(String str,
      {IconData? preIcon, Color? preIconColor, Duration? duration}) {
    ScaffoldMessenger.of(AppInitUtil().curContext!).showSnackBar(SnackBar(
        duration: duration ?? const Duration(milliseconds: 2000),
        dismissDirection: DismissDirection.up,
        backgroundColor: BaseColors.c828282,
        margin: EdgeInsets.only(bottom: 1.sh - 100.h, left: 20, right: 20),
        behavior: SnackBarBehavior.floating,
        content: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(str,
                style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.5,
                    fontWeight: BaseDimens.fw_m,
                    color: BaseColors.ffffff)))));
  }

  static RefreshIndicator getRefreshIndicator(Widget child, {onRefresh}) =>
      RefreshIndicator(
          backgroundColor: BaseColors.c161616,
          color: BaseColors.c00a0e7,
          onRefresh: onRefresh,
          child: child);

  static PreferredSizeWidget getInVisbileAppbar() => PreferredSize(
        preferredSize: Size.fromHeight(BaseUIUtil().getStatusHeight()),
        child: SafeArea(
          top: true,
          child: Offstage(),
        ),
      );

  static PreferredSizeWidget getAppbar(BuildContext context, String? title,
          {Widget? leftIcon,
          onLeftCilck,
          onRightClick,
          NormalListItem? rightItem,
          List<Widget>? actions,
          bool showLeft = true,
          bool showDivider = true,
          Color? backgroundColor,
          Color? titleColor,
          Widget? centerWidget}) =>
      AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: (Container(
                height: 1.h,
                width: 1.sw,
                color: showDivider
                    ? BaseUIUtil().getTheme().dividerColor
                    : BaseColors.trans))),
        title: centerWidget ??
            Text(
              title ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: BaseDimens.fw_l,
                  color: titleColor),
            ),
        centerTitle: true,
        actions: actions ??
            [
              Offstage(
                  offstage: rightItem == null,
                  child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 15).w,
                      padding: EdgeInsets.all(5.r),
                      child: _getNormalItemWithType(rightItem,
                          onItemRightClick: onRightClick)))
            ],
        leading: Offstage(
            offstage: !showLeft, //true=1为隐藏
            child: IconButton(
                icon: leftIcon ??
                    Icon(
                      BaseIcons.iconXiangzuo,
                      size: 16.w,
                    ),
                onPressed: () {
                  if (showLeft && onLeftCilck == null)
                    BaseRouteUtil.pop(context);
                  else
                    onLeftCilck();
                })),
      );

  static getRemoveTopView(BuildContext context, Widget widget) =>
      MediaQuery.removePadding(
          context: context, removeTop: true, removeBottom: true, child: widget);

  static Widget getBottomButton(String? str,
      {Function()? onPressed,
      bool includeBottomMargin = true,
      Color? backgroudColor,
      Color textColor = BaseColors.ffffff,
      FontWeight? fontWeight = BaseDimens.fw_l,
      double radius = 10.0,
      double? height,
      double width = double.infinity,
      double marginH = 0.0}) {
    Color bg = BaseUIUtil().getTheme().primaryIconTheme.color!;
    return Container(
        margin: EdgeInsets.only(
            bottom: includeBottomMargin! ? 25.h : 0,
            left: marginH,
            right: marginH),
        child: ElevatedButton(
            style: ButtonStyle(
                minimumSize:
                    MaterialStatePropertyAll<Size>(Size(width, height ?? 43.h)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius))),
                elevation: MaterialStateProperty.all(0),
                backgroundColor:
                    MaterialStatePropertyAll<Color>(backgroudColor ?? bg)),
            //MaterialStateColor.resolveWith((states) => BaseColors.e70012)
            onPressed: onPressed,
            child: Text(str ?? '',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: fontWeight,
                  color: textColor,
                ))));
  }

  static Widget getTextWithWidgetH(String primary,
          {required Widget? minor,
          double space = 5,
          TextStyle? primaryStyle,
          bool isLeft = true,
          double paddingV = 0,
          Function()? onTap,
          int maxLines = 1}) =>
      InkWell(
          onTap: onTap,
          child: RichText(
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                if (isLeft)
                  WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                          padding: EdgeInsets.only(
                              right: space, top: paddingV, bottom: paddingV),
                          child: minor)),
                WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Text(
                      primary,
                      style: primaryStyle,
                    )),
                //TextSpan(text: text, style: textStyle),
                if (!isLeft)
                  WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: space, top: paddingV, bottom: paddingV),
                        child: minor,
                      )),
              ],
            ),
          ));

  static Widget getTextWithWidgetV(
          {String? primary,
          TextStyle? primaryStyle,
          String? minor,
          TextStyle? minorStyle,
          Widget? minorWidget,
          double padding = 5,
          bool? isCenter = false,
          bool? isRight = false,
          bool? isPrimaryTop = true}) =>
      Column(
          crossAxisAlignment: isRight == true
              ? CrossAxisAlignment.end
              : (isCenter == true
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isPrimaryTop == true)
              Text(
                primary ?? '',
                style: primaryStyle,
              ),
            if (isPrimaryTop == true)
              Padding(padding: EdgeInsets.only(top: padding)),
            minorWidget ?? Text(minor ?? '', style: minorStyle),
            if (isPrimaryTop == false)
              Padding(padding: EdgeInsets.only(top: padding)),
            if (isPrimaryTop == false)
              Text(
                primary ?? '',
                style: primaryStyle,
              ),
          ]);

  static Widget getTextWithIconV(String text,
          {required IconData? icon,
          Function()? onTap,
          Color iconColor = BaseColors.ffffff,
          double? iconSize,
          TextStyle? textStyle,
          double padding = 5,
          MainAxisSize? mainAxisSize}) =>
      InkWell(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: mainAxisSize ?? MainAxisSize.max,
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: iconSize ?? 16.w,
                ),
                Padding(
                  padding: EdgeInsets.only(top: padding),
                ),
                Text(text,
                    style: textStyle ??
                        TextStyle(color: BaseColors.ffffff, fontSize: 12.sp))
              ]),
          onTap: onTap);

  static Widget getHorizontalListItem(int index, NormalListItem item,
          {Widget? divider,
          bool showDivider = false,
          onItemClick,
          onItemRightClick,
          bool titleCenter = false,
          double? iconPadding,
          double? prefixIconSize,
          double? itemVPadding,
          double itemHPadding = 0.0,
          bool suffixExpand = true,
          Color? checkBgColor,
          Color? disableBgColor = BaseColors.ebebeb,
          Color? disableTextColor = BaseColors.c828282}) =>
      Column(children: [
        GestureDetector(
            onTap: item.disable == true ? null : onItemClick,
            child: Container(
              color: item.disable == true
                  ? disableBgColor
                  : (item.itemChecked
                      ? (checkBgColor ?? BaseColors.trans)
                      : BaseColors.trans),
              padding: EdgeInsets.symmetric(
                  vertical: itemVPadding ?? 15.h, horizontal: itemHPadding),
              child: Row(
                mainAxisAlignment: titleCenter
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  if (item.prefixIconData != null)
                    Icon(item.prefixIconData,
                        color: item.prefixIconColor ??
                            BaseUIUtil().getThemeColor(BaseColors.c828282),
                        size: prefixIconSize ?? 18.h),
                  if (item.prefixChild != null) item.prefixChild!,
                  if (item.prefixIconData != null || item.prefixChild != null)
                    Padding(padding: EdgeInsets.only(left: iconPadding ?? 8.w)),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.primary!,
                            style: item.primaryStyle ??
                                TextStyle(
                                    color: item.disable
                                        ? disableTextColor
                                        : BaseUIUtil()
                                            .getTheme()
                                            .primaryTextTheme
                                            .displayMedium!
                                            .color)),
                        if (item.minor != null)
                          Text(item.minor!,
                              style: item.minorStyle ??
                                  BaseUIUtil()
                                      .getTheme()
                                      .primaryTextTheme
                                      .bodySmall),
                      ]),
                  if (item.rightType != ItemType.NONE)
                    if (suffixExpand)
                      Expanded(
                        child: Container(),
                      )
                    else
                      Padding(
                          padding: EdgeInsets.only(left: iconPadding ?? 8.w)),
                  if (item.rightType != ItemType.NONE)
                    _getNormalItemWithType(item,
                        onItemRightClick: onItemRightClick)
                ],
              ),
            )),
        if (divider != null && showDivider) divider
      ]);

  static Widget _getNormalItemWithType(NormalListItem? item,
      {onItemRightClick}) {
    switch (item?.rightType) {
      case ItemType.TEXT:
        return GestureDetector(
            onTap: onItemRightClick,
            child: Text(
              item?.suffixStr ?? '',
              style: item?.suffixStyle ??
                  BaseUIUtil().getTheme().primaryTextTheme.titleSmall,
            ));
      case ItemType.IMG:
        return Visibility(
            visible: item!.rightShow,
            child: onItemRightClick == null
                ? item!.suffixChild ??
                    Icon(Icons.chevron_right_outlined,
                        size: 20.r, color: BaseColors.a4a4a4)
                : GestureDetector(
                    onTap: onItemRightClick,
                    child: item?.suffixChild ??
                        Icon(Icons.chevron_right_outlined,
                            size: 20.r, color: BaseColors.a4a4a4)));

      case ItemType.WIDGET:
        return onItemRightClick == null
            ? item?.suffixChild ?? Container()
            : GestureDetector(
                onTap: onItemRightClick,
                child: item?.suffixChild ?? Container());
      case ItemType.SWITCH:
        return Container(
          height: 20.h,
          width: 20.w,
          child: Switch(
              value: item!.itemChecked,
              onChanged: (value) => onItemRightClick()),
        );
      default:
        return Container();
    }
  }

  static Widget getButtonCircleWithBorder({
    String? url,
    Function()? onTap,
    Widget? icon,
    Color? bgColor,
    Color borderColor = BaseColors.ffffff,
    double? size,
    double marginH = 0.0,
    double marginV = 0.0,
  }) {
    size = (size ?? 100.r);
    return BaseWidgetUtil.getButtonSized(
        marginH: marginH,
        marginV: marginV,
        aligment: null,
        onTap: onTap,
        height: size,
        width: size,
        color: bgColor ?? BaseColors.ffffff,
        circular: size / 2,
        borderColor: borderColor,
        borderWidth: 1.r,
        child: ClipOval(
          child: icon == null
              ? BaseImageUtil()
                  .getCachedImageWidget(url: url, showPlaceHolderImg: false)
              : icon,
        ));
  }

  static Widget getButtonOvalWithBorder(
      {String? url,
      Function()? onTap,
      Color? borderColor = BaseColors.ffffff,
      Color color = BaseColors.ffffff,
      double? size,
      double marginH = 0.0,
      double marginV = 0.0,
      double circular = 5.0,
      Widget? widget,
      BoxFit? fit,
      double borderWidth = 1}) {
    size = (size ?? 100.r);
    return BaseWidgetUtil.getButtonSized(
        marginH: marginH,
        marginV: marginV,
        aligment: null,
        onTap: onTap,
        height: size,
        width: size,
        color: color,
        circular: circular,
        borderColor: borderColor,
        borderWidth: borderWidth,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(circular),
          child: widget ??
              BaseImageUtil().getCachedImageWidget(
                  url: url, showPlaceHolderImg: false, fit: fit),
        ));
  }

  static Widget getContainerSized(
          {double paddingH = 0.0,
          double paddingV = 0.0,
          double marginH = 0.0,
          double marginV = 0.0,
          Widget? child,
          color = BaseColors.ffffff,
          double circular = 10.0,
          String? text,
          Color borderColor = BaseColors.trans,
          double borderWidth = 1.0,
          TextStyle? textStyle,
          Alignment? aligment = Alignment.center,
          double? height,
          double? width,
          BoxShape shape = BoxShape.rectangle}) =>
      Container(
          alignment: aligment,
          width: width,
          height: height,
          padding:
              EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
          margin: EdgeInsets.symmetric(horizontal: marginH, vertical: marginV),
          decoration: BoxDecoration(
            shape: shape,
            borderRadius: BorderRadius.circular(circular),
            border: Border.all(
              width: borderWidth,
              color: borderColor,
            ),
            color: color,
          ),
          child: child ??
              Text(text ?? '',
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis));

  static Widget getContainer(
          {double paddingH = 0.0,
          double paddingV = 0.0,
          double marginL = 0.0,
          double marginR = 0.0,
          double marginT = 0.0,
          double marginB = 0.0,
          Widget? child,
          Color color = BaseColors.ffffff,
          double circular = 10.0,
          String? text,
          Color borderColor = BaseColors.trans,
          double borderWidth = 1.0,
          TextStyle? textStyle,
          Alignment? aligment}) =>
      Container(
          alignment: aligment,
          margin: EdgeInsets.fromLTRB(marginL, marginT, marginR, marginB),
          padding:
              EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(circular),
            border: Border.all(
              width: borderWidth,
              color: borderColor,
            ),
            color: color,
          ),
          child: child ??
              Text(
                text ?? '',
                style: textStyle,
              ));

  static Widget getButtonSized(
          {double marginH = 0.0,
          double marginV = 0.0,
          double paddingH = 0.0,
          double paddingV = 0.0,
          String? text,
          Color? color,
          Color? borderColor,
          double circular = 5.0,
          TextStyle? textStyle,
          double? height,
          double? width,
          Widget? child,
          double borderWidth = 1.0,
          Alignment? aligment = Alignment.center,
          Function()? onTap}) =>
      InkWell(
          onTap: onTap,
          child: BaseWidgetUtil.getContainerSized(
              marginH: marginH,
              marginV: marginV,
              paddingH: paddingH,
              paddingV: paddingV,
              text: text,
              color: color ?? BaseUIUtil().getTheme().primaryColor,
              borderColor: borderColor ?? BaseColors.trans,
              circular: circular,
              textStyle: textStyle,
              child: child,
              width: width,
              height: height,
              aligment: aligment,
              borderWidth: borderWidth));

  static Widget getButton(
          {double paddingH = 0.0,
          double paddingV = 0.0,
          double marginL = 0.0,
          double marginR = 0.0,
          double marginT = 0.0,
          double marginB = 0.0,
          String? text,
          Color? color,
          Color? borderColor,
          double circular = 5.0,
          double borderWidth = 1.0,
          TextStyle? textStyle,
          Widget? child,
          Alignment? aligment,
          Function()? onTap}) =>
      InkWell(
          onTap: onTap,
          child: BaseWidgetUtil.getContainer(
              paddingH: paddingH,
              paddingV: paddingV,
              marginL: marginL,
              marginR: marginR,
              marginT: marginT,
              marginB: marginB,
              text: text,
              color: color ?? BaseUIUtil().getTheme().primaryColor,
              borderColor: borderColor ?? BaseColors.trans,
              circular: circular,
              textStyle: textStyle,
              child: child,
              borderWidth: borderWidth,
              aligment: aligment));

  static Widget getCircleButton(IconData icon, Function()? onTap,
          {double? size, Color? bg, Color? iconColor}) =>
      InkWell(
          onTap: onTap,
          child: CircleAvatar(
              radius: size ?? 16.r,
              backgroundColor: bg ?? BaseColors.c161616.withOpacity(0.4),
              child: Icon(
                icon,
                color: iconColor ?? BaseColors.ffffff,
                size: size ?? 16.r,
              )));

  static List<Shadow>? getShadow({double blur = 10}) => [
        Shadow(color: BaseColors.c11111, offset: Offset.zero, blurRadius: blur),
      ];
}

class NormalListItem {
  String? primary;
  TextStyle? primaryStyle;
  IconData? prefixIconData;
  Color? prefixIconColor;
  Widget? prefixChild;
  String? minor;
  TextStyle? minorStyle;
  String? suffixStr;
  TextStyle? suffixStyle;
  ItemType rightType;
  bool rightShow;
  Widget? suffixChild;
  Color itemBgColor;
  dynamic? type;
  bool itemChecked;
  bool disable = false;

  NormalListItem(
      {this.primary,
      this.primaryStyle,
      this.minor,
      this.minorStyle,
      this.suffixStr,
      this.suffixStyle,
      this.prefixIconData,
      this.prefixIconColor,
      this.prefixChild,
      this.rightType = ItemType.NONE,
      this.rightShow = true,
      this.suffixChild,
      this.itemChecked = false,
      this.itemBgColor = BaseColors.c161616,
      this.type});
}
