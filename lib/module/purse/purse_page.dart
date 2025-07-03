import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/module/purse/purse_recordlist_page.dart';
import 'package:djqs/module/purse/vm/purse_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PursePage extends StatefulWidget {
  PursePage({super.key});

  @override
  _PurseState createState() => _PurseState();
}

class _PurseState extends BasePageState<PursePage, PurseVM> {
  @override
  Widget build(BuildContext context) => buildViewModel<PurseVM>(
      appBar: BaseWidgetUtil.getAppbar(context, "我的收入"),
      create: (context) => PurseVM(context),
      viewBuild: (context, vm) => Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _todayView(),
            BaseGaps().vGap10,
            Divider(height: 10, thickness: 10, color: BaseColors.f5f5f5),
            BaseGaps().vGap10,
            _middleView(),
            BaseGaps().vGap10,
            Expanded(
                child: PurseRecordListPage(
                    startVN: vm.startVN, endVN: vm.endVN, dayVN: vm.dayVN))
          ])));

  Widget _todayView() => Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: BaseColors.f29b2d,
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.7],
              colors: [BaseColors.f29b2d, BaseColors.f96b56])),
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.all(10.r),
      child: Column(children: [
        // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //   BaseWidgetUtil.getTextWithWidgetV(
        //       padding: 1,
        //       primary: '钱包余额',
        //       primaryStyle: TextStyle(
        //           fontWeight: BaseDimens.fw_m,
        //           fontSize: 12.sp,
        //           color: BaseColors.ffffff),
        //       minorWidget: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           crossAxisAlignment: CrossAxisAlignment.baseline,
        //           textBaseline: TextBaseline.alphabetic,
        //           children: [
        //             Text(ObjectUtil.strToZero(vm.purseEntity?.balancetotal),
        //                 style: TextStyle(
        //                     fontWeight: BaseDimens.fw_l,
        //                     fontSize: 30.sp,
        //                     color: BaseColors.ffffff)),
        //             Text('元',
        //                 style: TextStyle(
        //                     fontWeight: BaseDimens.fw_m,
        //                     fontSize: 12.sp,
        //                     color: BaseColors.ffffff))
        //           ])),
        //   BaseWidgetUtil.getButton(
        //       paddingH: 15.w,
        //       circular: 3.r,
        //       paddingV: 5.h,
        //       color: BaseColors.ffe159,
        //       onTap: vm.btn_withdrawl,
        //       text: '提现',
        //       borderWidth: 0.0,
        //       textStyle: TextStyle(color: BaseColors.c161616, fontSize: 12.sp)),
        // ]),
        BaseGaps().vGap10,
        Row(children: [
          _topView_item(
              '今日收入', ObjectUtil.strToZero(vm.purseEntity?.totalIncome)),
          BaseGaps().hGap30,
          _topView_item(
              '今日支出', ObjectUtil.strToZero(vm.purseEntity?.totalExpense))
        ])
      ]));

  Widget _topView_item(String title, String minor) =>
      BaseWidgetUtil.getTextWithWidgetV(
          primary: title,
          primaryStyle: TextStyle(
              fontWeight: BaseDimens.fw_m,
              fontSize: 12.sp,
              color: BaseColors.ffffff),
          minorWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(minor,
                    style: TextStyle(
                        fontWeight: BaseDimens.fw_l,
                        fontSize: 26.sp,
                        color: BaseColors.ffffff)),
                Text('元',
                    style: TextStyle(
                        fontWeight: BaseDimens.fw_m,
                        fontSize: 12.sp,
                        color: BaseColors.ffffff))
              ]));

  Widget _middleView() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('今日账单',
            style: BaseUIUtil().getTheme().primaryTextTheme.displayLarge),
        BaseWidgetUtil.getTextWithWidgetH('查看历史账单',
            isLeft: false,
            primaryStyle: BaseUIUtil().getTheme().primaryTextTheme.bodyMedium,
            minor: Icon(Icons.chevron_right_outlined,
                size: 20.r, color: BaseColors.c828282),
            space: 1.w,
            onTap: vm.btn_gotoHistory)
      ]));
}
