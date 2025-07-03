import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatUtil {
  static getTabbar(TabController? tabController, BuildContext context,
          List<String> titles) =>
      Container(
          color: BaseColors.ffffff,
          width: 1.sw,
          padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
          child: TabBar(
            controller: tabController,
            indicatorColor:
                BaseUIUtil().getTheme(context: context).indicatorColor,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 5.w),
            indicatorSize: TabBarIndicatorSize.label,
            enableFeedback: false,
            labelColor: BaseColors.c161616,
            labelStyle: tabTextStyle(),
            unselectedLabelColor: BaseColors.c828282,
            isScrollable: true,
            tabs: titles.map((item) => Tab(text: item)).toList(),
          ));

  static TextStyle tabTextStyle() => TextStyle(
      color: BaseColors.c828282, fontSize: 14.sp, fontWeight: BaseDimens.fw_l);
}
