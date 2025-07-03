import 'package:djqs/app/app_util.dart';
import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/module/stat/entity/stat_month_entity.dart';
import 'package:djqs/module/stat/stat_orderlist_page.dart';
import 'package:djqs/module/stat/util/stat_util.dart';
import 'package:djqs/module/stat/vm/stat_order_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderStatPage extends StatefulWidget {
  OrderStatPage({super.key});

  @override
  _OrderStatState createState() => _OrderStatState();
}

class _OrderStatState extends BasePageState<OrderStatPage, StatOrderVM>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    if (_tabController == null)
      _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) => buildViewModel<StatOrderVM>(
      appBar: BaseWidgetUtil.getAppbar(context, "订单统计"),
      create: (context) => StatOrderVM(context),
      viewBuild: (context, vm) => Container(
            color: BaseColors.ffffff,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatUtil.getTabbar(_tabController, context, ['今日订单', '月订单']),
                Expanded(child: _tabBarView())
              ],
            ),
          ));

  Widget _tabBarView() => TabBarView(
      controller: _tabController,
      children: <Widget>[_todayOrderView(), _monthListView()]);

  Widget _todayOrderView() => Column(
      children: [_todayOrderView_top(), Expanded(child: StatOrderPage())]);

  Widget _todayOrderView_top() => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: BaseColors.f29b2d,
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.0, 0.7],
                colors: [BaseColors.f29b2d, BaseColors.f96b56])),
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        padding: EdgeInsets.only(top: 5.h, left: 5.w, right: 5.w),
        child: GridView.builder(
            itemCount: vm.todayGridData.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.2.w,
              crossAxisSpacing: 5.w,
              mainAxisSpacing: 0,
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) =>
                _today_gridview_item(vm.todayGridData[index], index)),
      );

  Widget _today_gridview_item(NormalListItem item, int index) =>
      BaseWidgetUtil.getTextWithWidgetV(
          isPrimaryTop: false,
          isCenter: true,
          primary: item.primary,
          primaryStyle: TextStyle(
              fontWeight: BaseDimens.fw_m,
              fontSize: 12.sp,
              color: BaseColors.ffffff),
          minorWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.minor ?? '',
                  style: TextStyle(
                      fontWeight: BaseDimens.fw_l,
                      fontSize: 18.sp,
                      color: BaseColors.ffffff)),
              Text(
                  index == vm.todayGridData.length - 1
                      ? AppUtil().getDistance(vm.statTodayEntity?.distance)[1]
                      : '单',
                  style: TextStyle(
                      fontWeight: BaseDimens.fw_m,
                      fontSize: 12.sp,
                      color: BaseColors.ffffff))
            ],
          ));

  Widget _monthListView() => Container(
        child: Column(
          children: [
            Divider(height: 2,thickness: 2,color: BaseColors.f5f5f5),
            BaseGaps().vGap10,
            ListView.builder(
                shrinkWrap: true,
                itemCount: vm.monthListData?.length,
                itemBuilder: (BuildContext context, int index) =>
                    _month_listview_item(vm.monthListData?[index])),
            Expanded(child: Container(color: BaseColors.f5f5f5))
          ],
        ),
      );

  Widget _month_listview_item(StatMonthEntity? item) => Padding(
        padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
        child: BaseWidgetUtil.getTextWithWidgetV(
            primary: item?.title,
            primaryStyle: TextStyle(
                fontWeight: BaseDimens.fw_l_x,
                fontSize: 14.sp,
                color: BaseColors.c161616),
            padding: 5.h,
            minorWidget: Column(children: [
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    month_item_txt('完成订单', item?.orders),
                    month_item_txt('转单', item?.transfers),
                    month_item_txt(
                        '配送里程',
                        AppUtil()
                            .getDistance(int.parse(ObjectUtil.strToZero(item?.distance) ))[0],
                        subMinor: AppUtil()
                            .getDistance(int.parse(ObjectUtil.strToZero(item?.distance)))[1])
                  ])
            ])),
      );

  Widget month_item_txt(String primary, String? minor,
          {String subMinor = '单'}) =>
      BaseWidgetUtil.getTextWithWidgetV(
          isCenter: true,
          primary: primary,
          primaryStyle: TextStyle(
              fontWeight: BaseDimens.fw_m,
              fontSize: 12.sp,
              color: BaseColors.a4a4a4),
          minorWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(minor ?? '',
                  style: TextStyle(
                      fontWeight: BaseDimens.fw_m,
                      fontSize: 16.sp,
                      color: BaseColors.c161616)),
              Text(subMinor,
                  style: TextStyle(
                      fontWeight: BaseDimens.fw_m,
                      fontSize: 12.sp,
                      color: BaseColors.c161616))
            ],
          ));
}
