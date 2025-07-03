import 'package:app_settings/app_settings.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/common/module/setting/volume_setting_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeUtil {
  static const TYPE_HOMESETTING_LOCATION = 0;
  static const TYPE_HOMESETTING_NOTI = 1;

  List<NormalListItem> _settingData = [];

  factory HomeUtil() => _instance;
  static late final HomeUtil _instance = HomeUtil._internal();

  HomeUtil._internal() {
    _settingData.add(NormalListItem(
        type: TYPE_HOMESETTING_LOCATION,
        primary: '手机定位权限',
        primaryStyle: BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
        suffixChild: _itemRightView(),
        rightType: ItemType.WIDGET));
    _settingData.add(NormalListItem(
        type: TYPE_HOMESETTING_NOTI,
        primary: '接收通知权限',
        primaryStyle: BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
        suffixChild: _itemRightView(),
        rightType: ItemType.WIDGET));
  }

  Widget _itemRightView() => BaseWidgetUtil.getContainer(
      paddingH: 5.w,
      paddingV: 2.h,
      borderColor: BaseColors.f29b2d,
      circular: 2.0,
      text: '去设置',
      textStyle: TextStyle(color: BaseColors.f29b2d, fontSize: 13.sp));

  void showListBS(BuildContext context) => showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(2).w),
      ),
      context: context,
      builder: (BuildContext buildContext) => Container(
            margin:
                EdgeInsets.only(top: 5.h, bottom: 2.h, left: 15.w, right: 15.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BaseWidgetUtil.getContainerSized(
                    width: 35.w, height: 5.h, color: BaseColors.c4f4f4f),
                BaseGaps().vGap15,
                Stack(children: [
                  Align(
                      alignment: Alignment.center,
                      child: Text('接单提醒设置',
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
                    child: Column(children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: _settingData!.length,
                          itemBuilder: (itemcontext, index) {
                            return BaseWidgetUtil.getHorizontalListItem(
                                index, _settingData![index],
                                onItemRightClick: () =>
                                    btn_onItemClick(_settingData![index].type),
                                itemHPadding: 10.w,
                                showDivider: false);
                          }),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10.w, right: 10.w, bottom: 25.h),
                          child: VolumeSettingWidget(
                              titleTextStyle: BaseUIUtil()
                                  .getTheme()
                                  .primaryTextTheme
                                  .displayMedium))
                    ])),
              ],
            ),
          ));

  void btn_onItemClick(type) {
    switch (type) {
      case TYPE_HOMESETTING_LOCATION:
        AppSettings.openAppSettings(type: AppSettingsType.location);
        break;
      case TYPE_HOMESETTING_NOTI:
        AppSettings.openAppSettings(type: AppSettingsType.notification);
        break;
    }
  }
}
