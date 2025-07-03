import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_string.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/module/home/viewmodel/home_slide_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSlidePage extends StatefulWidget {
  const HomeSlidePage({Key? key}) : super(key: key);

  @override
  State<HomeSlidePage> createState() => _HomeSlidePageState();
}

class _HomeSlidePageState extends BasePageState<HomeSlidePage, HomeSlideVM> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => buildViewModel<HomeSlideVM>(
      safeArea: false,
      backPress: true,
      create: (context) => HomeSlideVM(context),
      viewBuild: (context, vm) => _drawer());

  Widget _drawer() => SizedBox(
        child: Drawer(
            shadowColor: BaseColors.c161616,
            width: 280.w,
            child: Container(
                margin: EdgeInsets.only(top: 40.h),
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(children: [
                  BaseGaps().vGap50,
                  _userView(),
                  BaseGaps().vGap20,
                  _topGridListView(vm.gridTopData,
                      onItemClick: vm.btn_onTopGridItemClick),
                  // BaseGaps().vGap20,
                  _bottomListView(),
                ]))),
      );

  Widget _userView() => Row(children: [
        BaseWidgetUtil.getButtonCircleWithBorder(
            size: 50.r, url: AccountUtil().getAccount()?.avatar),
        BaseGaps().hGap10,
        BaseWidgetUtil.getTextWithWidgetV(
            primary: AccountUtil().getAccount()?.userNickname,
            primaryStyle: BaseUIUtil().getTheme().primaryTextTheme.displayLarge,
            minor: BaseStrUtil.getEncryptNumber(
                AccountUtil().getAccount()?.mobile ?? ''),
            minorStyle: BaseUIUtil().getTheme().primaryTextTheme.titleSmall,
            padding: 5.h),
      ]);

  Widget _topGridListView(List<NormalListItem> data,
          {Function(int index)? onItemClick}) =>
      GridView.builder(
        padding: EdgeInsets.zero,
          itemCount: data.length,
          physics:const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.w,
            crossAxisCount: data.length,
          ),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () => onItemClick?.call(index),
                child: BaseWidgetUtil.getTextWithWidgetV(
                    isCenter: true,
                    primary: data[index].minor,
                    primaryStyle:
                        BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
                    minorWidget: data[index].prefixIconData == null
                        ? Text(data[index].primary ?? '',
                            style: BaseUIUtil()
                                .getTheme()
                                .primaryTextTheme
                                .bodySmall)
                        : BaseWidgetUtil.getTextWithWidgetH(
                            data[index].primary ?? '',
                            primaryStyle: BaseUIUtil()
                                .getTheme()
                                .primaryTextTheme
                                .bodySmall,
                            minor: Icon(Icons.chevron_right_outlined,
                                size: 13.r, color: BaseColors.a4a4a4),
                            isLeft: false,
                            space: 1.w),
                    padding: 2,
                    minorStyle:
                        BaseUIUtil().getTheme().primaryTextTheme.bodySmall));
          });

  Widget _bottomListView() => ListView.builder(
      physics:const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: vm.listData.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return BaseWidgetUtil.getHorizontalListItem(index, vm.listData[index],
            iconPadding: 10.w,
            prefixIconSize: 15.r,
            itemVPadding: 15.h,
            showDivider: true,
            onItemClick: () =>
                vm.btn_onBottomListItemClick(vm.listData[index]));
      });
}
