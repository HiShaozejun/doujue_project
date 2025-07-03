import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/util/util_image.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/common/module/start/util/app_init_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'base_widget.dart';

class BaseDialogUtil {
  static void showLoadingDialog(
          {BuildContext? context, bool? barrierDismissible}) =>
      showDialog<void>(
          context: context ?? AppInitUtil().curContext!,
          barrierDismissible: barrierDismissible ?? true,
          builder: (_) => Center(
                child: CircularProgressIndicator(),
              ));

  static void showListBS(BuildContext context,
          {String? title,
          bool titleCenter = true,
          List<NormalListItem>? topData,
          Function? onTopItemClick,
          List<NormalListItem>? bottomData,
          Function? onBottomItemClick}) =>
      showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20).w),
          ),
          context: context,
          builder: (BuildContext buildContext) => Container(
                margin: EdgeInsets.only(
                    top: 5.h, bottom: 2.h, left: 15.w, right: 15.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BaseWidgetUtil.getContainerSized(
                        width: 35.w, height: 5.h, color: BaseColors.c4f4f4f),
                    BaseGaps().vGap15,
                    Stack(children: [
                      if (!ObjectUtil.isEmptyStr(title))
                        Align(
                            alignment: Alignment.center,
                            child: Text(title ?? '',
                                style: BaseUIUtil()
                                    .getTheme()
                                    .primaryTextTheme
                                    .displayLarge)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: BaseWidgetUtil.getButton(
                            color: BaseColors.trans,
                            paddingH: 5.h,
                            paddingV: 5.w,
                            borderColor: BaseColors.trans,
                            child: Icon(Icons.close,
                                size: 20.r, color: BaseColors.c4f4f4f),
                            onTap: () => Navigator.pop(buildContext)),
                      )
                    ]),
                    BaseGaps().vGap15,
                    BaseWidgetUtil.getContainer(
                        color: BaseUIUtil().isThemeDark()
                            ? BaseColors.c393939
                            : BaseColors.ffffff,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: topData!.length,
                            itemBuilder: (itemcontext, index) {
                              return BaseWidgetUtil.getHorizontalListItem(
                                  index, topData![index],
                                  prefixIconSize: 20.r,
                                  onItemClick: () => onTopItemClick!(
                                      buildContext, context, index),
                                  titleCenter: titleCenter,
                                  itemHPadding: 25.w,
                                  showDivider: (index == topData!.length - 1
                                      ? false
                                      : true),
                                  divider:
                                      Divider(indent: 25.w, endIndent: 25.w));
                            })),
                    BaseGaps().vGap15,
                    if (bottomData != null)
                      BaseWidgetUtil.getContainer(
                        color: BaseUIUtil().isThemeDark()
                            ? BaseColors.c393939
                            : BaseColors.ffffff,
                        child: ListView.builder(
                            physics: new NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: bottomData!.length,
                            itemBuilder: (itemcontext, index) {
                              return BaseWidgetUtil.getHorizontalListItem(
                                  index, bottomData![index],
                                  prefixIconSize: 20.r,
                                  onItemClick: () => onBottomItemClick!(
                                      buildContext, context, index),
                                  titleCenter: titleCenter,
                                  itemHPadding: 25.w,
                                  showDivider: (index == bottomData!.length - 1
                                      ? false
                                      : true),
                                  divider:
                                      Divider(indent: 25.w, endIndent: 25.w));
                            }),
                      ),
                    if (bottomData != null) BaseGaps().vGap15
                  ],
                ),
              ));

  static void showListBSLH(BuildContext context,
          {String? title,
          bool titleCenter = true,
          List<NormalListItem>? topData,
          Function? onTopItemClick,
          List<NormalListItem>? bottomData,
          Function? onBottomItemClick,
          double maxHeight = 500}) =>
      showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20).w),
          ),
          context: context,
          builder: (BuildContext buildContext) => Container(
                constraints: BoxConstraints(maxHeight: maxHeight),
                margin: EdgeInsets.only(
                    top: 5.h, bottom: 2.h, left: 15.w, right: 15.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BaseWidgetUtil.getContainerSized(
                        width: 35.w, height: 5.h, color: BaseColors.c4f4f4f),
                    BaseGaps().vGap15,
                    Stack(children: [
                      if (!ObjectUtil.isEmptyStr(title))
                        Align(
                            alignment: Alignment.center,
                            child: Text(title ?? '',
                                style: BaseUIUtil()
                                    .getTheme()
                                    .primaryTextTheme
                                    .displayLarge)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: BaseWidgetUtil.getButton(
                            color: BaseColors.trans,
                            paddingH: 5.h,
                            paddingV: 5.w,
                            borderColor: BaseColors.trans,
                            child: Icon(Icons.close,
                                size: 20.r, color: BaseColors.c4f4f4f),
                            onTap: () => Navigator.pop(buildContext)),
                      )
                    ]),
                    BaseGaps().vGap15,
                    Expanded(
                        child: BaseWidgetUtil.getContainer(
                            color: BaseUIUtil().isThemeDark()
                                ? BaseColors.c393939
                                : BaseColors.ffffff,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: topData!.length,
                                itemBuilder: (itemcontext, index) {
                                  return BaseWidgetUtil.getHorizontalListItem(
                                      index, topData![index],
                                      prefixIconSize: 20.r,
                                      onItemClick: () => onTopItemClick!(
                                          buildContext, context, index),
                                      titleCenter: titleCenter,
                                      itemHPadding: 25.w,
                                      showDivider: (index == topData!.length - 1
                                          ? false
                                          : true),
                                      divider: Divider(
                                          indent: 25.w, endIndent: 25.w));
                                }))),
                    BaseGaps().vGap15,
                    if (bottomData != null)
                      BaseWidgetUtil.getContainer(
                        color: BaseUIUtil().isThemeDark()
                            ? BaseColors.c393939
                            : BaseColors.ffffff,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: bottomData!.length,
                            itemBuilder: (itemcontext, index) {
                              return BaseWidgetUtil.getHorizontalListItem(
                                  index, bottomData![index],
                                  prefixIconSize: 20.r,
                                  onItemClick: () => onBottomItemClick!(
                                      buildContext, context, index),
                                  titleCenter: titleCenter,
                                  itemHPadding: 25.w,
                                  showDivider: (index == bottomData!.length - 1
                                      ? false
                                      : true),
                                  divider:
                                      Divider(indent: 25.w, endIndent: 25.w));
                            }),
                      ),
                    if (bottomData != null) BaseGaps().vGap15
                  ],
                ),
              ));

  static void showLightListBS(BuildContext context,
          {String? title,
          @required int? length,
          @required itemBuilder,
          Function()? onItemClick}) =>
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 400.h,
            child: Column(children: [
              BaseGaps().vGap10,
              Text(title ?? '',
                  style:
                      BaseUIUtil().getTheme().primaryTextTheme.displayMedium),
              Padding(padding: EdgeInsets.only(top: 10.h)),
              Expanded(
                child: ListView.builder(
                    itemCount: length ?? 0, itemBuilder: itemBuilder),
                flex: 1,
              ),
            ]),
          );
        },
      );

  static void showCommonDialog(BuildContext? context,
          {String? title,
          String? content,
          Widget? contentWidget,
          Function()? onPosBtn,
          Function()? onNagBtn,
          String? leftBtnStr = '取消',
          String? rightBtnStr = '确定',
          bool isPopDialog = true}) =>
      showDialog<void>(
          context: context ?? AppInitUtil().curContext!,
          barrierDismissible: onPosBtn == null ? true : false,
          builder: (BuildContext buildContext) => PopScope(
              canPop: onPosBtn == null ? false : true,
              child: AlertDialog(
                  title: Text(title ?? ''),
                  content: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: contentWidget ?? Text(content ?? '')),
                  actions: [
                    if (leftBtnStr != null)
                      TextButton(
                        child: Text(leftBtnStr),
                        onPressed: () async {
                          if (isPopDialog) Navigator.pop(buildContext);
                          onNagBtn?.call();
                        },
                      ),
                    if (rightBtnStr != null)
                      TextButton(
                          child: Text(rightBtnStr),
                          onPressed: () async {
                            if (isPopDialog) Navigator.pop(buildContext);
                            onPosBtn?.call();
                          })
                  ])));

  static void showWarnDialog(BuildContext context,
          {required String imagePath,
          String? content,
          Widget? contentWidget,
          Function()? onPosBtn,
          String? leftBtnStr = '取消',
          String? rightBtnStr = '确定',
          bool barrierDismissible = true}) =>
      showDialog<void>(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: (BuildContext buildContext) => PopScope(
                canPop: barrierDismissible ? true : true,
                child: AlertDialog(
                  shadowColor: BaseColors.trans,
                  backgroundColor: BaseColors.trans,
                  surfaceTintColor: BaseColors.trans,
                  content: Container(
                    child: Stack(children: [
                      Container(
                          margin: EdgeInsets.only(top: 35),
                          height: 180.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: BaseUIUtil()
                                  .getTheme()
                                  .dialogTheme
                                  .backgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r))),
                          child: Column(children: [
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.only(top: 55),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: contentWidget ??
                                        Text(content ?? '',
                                            style: BaseUIUtil()
                                                .getTheme()
                                                .textTheme
                                                .titleMedium))),
                            if (rightBtnStr != null)
                              BaseWidgetUtil.getBottomButton(rightBtnStr,
                                  includeBottomMargin: false,
                                  height: 35.h,
                                  width: 200.w,
                                  radius: 20.r,
                                  marginH: 20.w, onPressed: () async {
                                Navigator.pop(buildContext);
                                onPosBtn?.call();
                              }),
                            BaseGaps().vGap15
                          ])),
                      Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          child: BaseImageUtil().getRawImg(imagePath,
                              height: 70, width: 70, fit: BoxFit.scaleDown))
                    ]),
                  ),
                ),
              ));
}
