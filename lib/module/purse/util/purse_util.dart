import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/module/purse/entity/purse_today_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PurseUtil {
  static Widget getPurseItemView(PurseItemEntity? item) => Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical:  10.h),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BaseWidgetUtil.getTextWithWidgetV(
                        primary: item?.actionTxt,
                        primaryStyle: BaseUIUtil()
                            .getTheme()
                            .primaryTextTheme
                            .displayMedium,
                        padding: 2.h,
                        minor: item?.addTime),
                    Text(
                      item?.totalVale ?? '',
                      style: TextStyle(
                          fontWeight: BaseDimens.fw_l_x,
                          fontSize: 14.sp,
                          color: BaseColors.c161616),
                    )
                  ])),
          Divider(height: 1.h, thickness: 1.h, color: BaseColors.ebebeb)
        ],
      );
}
