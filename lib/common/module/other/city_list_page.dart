import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/widget/azlistview/az_common.dart';
import 'package:djqs/base/widget/azlistview/az_listview.dart';
import 'package:djqs/common/module/other/entity/citylist_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'viewmodel/citylist_vm.dart';

class CityListPage extends StatefulWidget {
  @override
  _CityListPageState createState() => _CityListPageState();
}

class _CityListPageState extends BasePageState<CityListPage, CityListVM> {
  @override
  Widget build(BuildContext context) => buildViewModel<CityListVM>(
      appBar: BaseWidgetUtil.getAppbar(context, "城市选择"),
      create: (context) => CityListVM(context),
      viewBuild: (context, vm) => Container(
              child: AzListView(
            locationBean: CityEntity.index('location', tag: '定位'),
            hotBean: CityEntity.index('hot', tag: '热门'),
            data: vm.cityList,
            itemBuilder: (context, ISuspensionBean entity) =>
                _buildListItem(entity as CityEntity),
            suspensionWidget: _buildSusWidget(vm.curSusTag!),
            isUseRealIndex: true,
            onSusTagChanged: (tag) => vm.curSusTag = tag,
            indexBarItemHeight: 20,
            //showCenterTip: false,
          )));

  Widget _buildListItem(CityEntity entity) {
    switch (entity.name) {
      case 'location':
        return _locationView();
      case 'hot':
        return _hotView();
      default:
        return _cityView(entity);
    }
  }

  Widget _cityView(CityEntity entity) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Offstage(
              offstage: entity.isShowSuspension != true,
              child: _buildSusWidget(entity.getSuspensionTag())),
          InkWell(
            onTap: () => vm.btn_onSelectCity(cityEntity: entity),
            child: Container(
              color: BaseUIUtil().getTheme().primaryColor,
              padding: EdgeInsets.only(left: 15.w, top: 5.h, bottom: 5.h),
              alignment: Alignment.centerLeft,
              child: Text(entity.name!,
                  style:
                      BaseUIUtil().getTheme().primaryTextTheme.displayMedium),
            ),
          ),
          Divider(height: 1.h)
        ],
      );

  Widget _buildSusWidget(String susTag) => Offstage(
        offstage: susTag == '' || susTag == '定位' || susTag == '热门',
        child: Container(
          padding: EdgeInsets.only(left: 15.w, top: 5.h, bottom: 5.h),
          color: BaseUIUtil().isThemeDark()
              ? BaseColors.c262626
              : BaseColors.ebebeb,
          alignment: Alignment.centerLeft,
          child: Text('$susTag',
              style: BaseUIUtil().getTheme().primaryTextTheme.displaySmall),
        ),
      );

  Widget _locationView() => Container(
        padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('当前定位',
                  style: BaseUIUtil().getTheme().primaryTextTheme.displaySmall),
              BaseGaps().vGap5,
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                BaseWidgetUtil.getButtonSized(
                  width: 100.w,
                  height: 30.h,
                  paddingH: 5.w,
                  child: BaseWidgetUtil.getTextWithWidgetH(
                      '${vm.getCurrentLocation()}',
                      primaryStyle:
                          BaseUIUtil().getTheme().primaryTextTheme.displaySmall,
                      minor: Icon(
                        Icons.location_on,
                        size: 12.sp,
                        color: BaseColors.e70012,
                      )),
                  onTap: () => vm.btn_onSelectCity(isFromLocation: true),
                  borderColor: BaseUIUtil().getTheme().dividerColor,
                ),
                InkWell(
                  onTap: vm.btn_onStartLocation,
                  child: Text(
                    vm.isLocating ? '正在定位..' : '重新定位',
                    style:
                        BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
                  ),
                ),
              ])
            ]),
      );

  Widget _hotView() => Container(
        padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('热门城市',
                  style: BaseUIUtil().getTheme().primaryTextTheme.displaySmall),
              BaseGaps().vGap5,
              Wrap(
                spacing: 15.w,
                runSpacing: 5.h,
                children: vm.hotCityList
                    .map<Widget>((entity) => _hotItem(entity))
                    .toList(),
              ),
              BaseGaps().vGap10,
              Text('所有城市',
                  style: BaseUIUtil().getTheme().primaryTextTheme.displaySmall),
              BaseGaps().vGap5
            ]),
      );

  Widget _hotItem(CityEntity entity) => BaseWidgetUtil.getButtonSized(
      text: '${entity.name ?? ''}',
      width: 100.w,
      paddingH: 5.w,
      height: 30.h,
      borderColor: BaseUIUtil().getTheme().dividerColor,
      textStyle: BaseUIUtil().getTheme().primaryTextTheme.displaySmall,
      onTap: () => vm.btn_onSelectCity(cityEntity: entity));
}
