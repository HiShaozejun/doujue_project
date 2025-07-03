import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_countdown.dart';
import 'package:djqs/base/util/util_debug.dart';
import 'package:djqs/base/util/util_image.dart';
import 'package:djqs/base/util/util_upgrade.dart';
import 'package:djqs/base/widget/debounce_event_widget.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/module/home/home_slider.dart';
import 'package:djqs/module/home/viewmodel/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends BasePageState<HomePage, HomeVM>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();
  TabController? tabController;

  void _initData() {
    tabController = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  void onAppResume() => vm.onAppResume();

  @override
  Widget build(BuildContext context) {
    _initData();
    return buildViewModel<HomeVM>(
        safeArea: false,
        backPress: true,
        create: (context) => HomeVM(context, tabController),
        viewBuild: (context, vm) => BaseUpgradeUtil().getUpgradeView(
                child: Listener(
              onPointerDown: (_) => vm.resetRefreshTime(),
              onPointerMove: (_) => vm.resetRefreshTime(),
              onPointerUp: (_) => vm.resetRefreshTime(),
              child: Scaffold(
                  key: _scaffoldKey,
                  resizeToAvoidBottomInset: false,
                  drawer:const HomeSlidePage(),
                  appBar: BaseWidgetUtil.getAppbar(context, '',
                      centerWidget: _titleView(),
                      backgroundColor: BaseColors.c2c4b6d,
                      titleColor: BaseColors.ffffff,
                      onLeftCilck: () =>
                          _scaffoldKey.currentState?.openDrawer(),
                      leftIcon: Builder(
                          builder: (context) => Container(
                              padding: EdgeInsets.all(5.r),
                              child: Icon(Icons.person,
                                  size: 30.r, color: BaseColors.ffffff)))),
                  body: Column(
                    children: [
                      _tabbar(vm.btn_onTabRepeat),
                      Expanded(child: tabbarView()),
                      _bottomView()
                    ],
                  )),
            )));
  }

  Widget _titleView() => PopupMenuButton<String>(
      onSelected: (value) => vm.btn_onChageUserState(),
      position: PopupMenuPosition.under,
      color: BaseColors.trans,
      offset: Offset(-55, -5),
      onOpened: () => vm.goto_changeShowPop(true),
      onCanceled: () => vm.goto_changeShowPop(false),
      itemBuilder: (context) => [
            PopupMenuItem(
                value: '1',
                child: Center(
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 25, right: 25, bottom: 15, top: 25),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: AssetImage(BaseImageUtil()
                                    .getAssetImgPath('app_bianzu')))),
                        child: BaseWidgetUtil.getTextWithWidgetH(
                            AccountUtil().getAccount()?.getRestStr(
                                    AccountUtil().getAccount()?.restOpsValue,
                                    isPop: true) ??
                                '',
                            primaryStyle: TextStyle(
                                fontWeight: BaseDimens.fw_m,
                                fontSize: 14,
                                color: BaseColors.ffffff),
                            minor: Icon(AccountUtil().isRest ? Icons.delivery_dining : Icons.coffee,
                                size: 18, color: BaseColors.ffffff),
                            isLeft: true,
                            space: 10))))
          ],
      child: BaseWidgetUtil.getTextWithWidgetH(
        AccountUtil()
                .getAccount()
                ?.getRestStr(AccountUtil().getAccount()?.isrest) ??
            '',
        primaryStyle: TextStyle(
            fontWeight: BaseDimens.fw_l,
            fontSize: 15.sp,
            color: BaseColors.ffffff),
        minor: Icon(
            vm.isPopShow
                ? Icons.keyboard_arrow_down_outlined
                : Icons.keyboard_arrow_up_outlined,
            size: 20.r,
            color: BaseColors.ffffff),
        isLeft: false,
        space: 1.w,
      ));

  Widget tabbarView() => ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 1.sw,
        maxHeight: 1.sh,
      ),
      child: TabBarView(
        controller: vm.tabController,
        children: vm.tabWidgetList,
      ));

  Widget _tabbar(Function(int index)? onTab) => Container(
        width: 1.sw,
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.only(right: 15.w, left: 10.w),
          padding: EdgeInsets.symmetric(vertical: 5.h),
          indicator:const UnderlineTabIndicator(
              borderSide: BorderSide(width: 2.5, color: BaseColors.c161616),
              insets: EdgeInsets.only(top: 1)),
          labelColor: BaseColors.c161616,
          labelStyle: _tabTextStyle(),
          unselectedLabelColor: BaseColors.c828282,
          unselectedLabelStyle: _tabTextStyle(),
          enableFeedback: false,
          dividerHeight: 0,
          isScrollable: false,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          tabs: vm.tabData.map((HomeTabData item) => _tabView(item)).toList(),
          controller: vm.tabController,
          onTap: onTab,
        ),
      );

  Widget _tabView(HomeTabData item) => FittedBox(
        child: Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Badge.count(
                backgroundColor: BaseColors.fc3e5a,
                count: item.dotValue,
                isLabelVisible: item.dotValue == 0 ? false : true,
                child: Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: Text(item.title ?? '')))),
      );

  TextStyle _tabTextStyle() => TextStyle(
      color: BaseColors.c828282, fontSize: 14.sp, fontWeight: BaseDimens.fw_l);

  Widget _bottomView() => Container(
      height: 70.h,
      padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 15.h),
      color: BaseColors.f5f5f5,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        BaseWidgetUtil.getTextWithIconV('接单设置',
            icon: Icons.tune,
            iconColor: BaseColors.c161616,
            iconSize: 23.r,
            textStyle: BaseUIUtil().getTheme().primaryTextTheme.displaySmall,
            onTap: vm.btn_showSetting),
        Expanded(
            child: DebounceGestureDetector(
          onTap: () => vm.btn_onRefresh(vm.tabController?.index),
          child: Container(
            height: 45.h,
              margin: EdgeInsets.only(left: 20.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  width: 1,
                  color: BaseColors.a4a4a4,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BaseWidgetUtil.getTextWithWidgetH('刷新列表',
                      primaryStyle: BaseUIUtil()
                          .getTheme()
                          .primaryTextTheme
                          .displayMedium,
                      minor: Icon(Icons.wifi_protected_setup,
                          size: 20.r, color: BaseColors.c161616),
                      space: 1.w),
                  if (BaseDebugUtil().isDebug())
                    ValueListenableBuilder<int?>(
                      valueListenable: vm.refreshCDUtil.cdVN,
                      builder: (context, value, child) => Text(
                        '$value 秒后刷新 测试展示用',
                        style:
                           const TextStyle(color: BaseColors.e70012, fontSize: 14),
                      ),
                    )
                ],
              )),
        ))
      ]));

  @override
  bool get wantKeepAlive => true;
}
