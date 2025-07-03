import 'package:djqs/base/extensions/function_extensions.dart';
import 'package:djqs/base/frame/base_lifecycle_observer.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/route/base_route_manager.dart';
import 'package:djqs/base/route/base_route_oberver.dart';
import 'package:djqs/base/ui/base_theme_notifier.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_clipboard.dart';
import 'package:djqs/base/util/util_countdown.dart';
import 'package:djqs/base/util/util_date.dart';
import 'package:djqs/base/util/util_log.dart';
import 'package:djqs/base/util/util_methodchannel.dart';
import 'package:djqs/base/util/util_timer.dart';
import 'package:djqs/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'base_notifier.dart';

abstract class BasePageState<T extends StatefulWidget, VM extends BaseNotifier>
    extends State<T> with RouteAware {
  PageLifecycleState _lifecycleState = PageLifecycleState.unInitialized;

  bool _isAppPause = false; // app前后台切换标志位
  bool _hasAddStartChange = false; // 页面start监听绑定标识位
  bool _hasAddPauseChange = false;
  bool _hasAddResumeChange = false;
  final _onStartChange = ChangeNotifier(); // 页面start监听器
  final _onPauseChange = ChangeNotifier();
  final _onResumeChange = ChangeNotifier();

  final int limitMillisecond = 2000;
  int firstTime = 0;

  late VM vm;

  @override
  void initState() {
    super.initState();
    BaseLogUtil().d('当前类: $runtimeType');
    BaseLifecycleObserver().lifecycleState.addListener(_dealWithAppLifecycle);
  }

  bool get isCurrent => ModalRoute.of(context)?.isCurrent ?? false;

  void safeSetState(Function callback) {
    if(mounted){
      callback();
    }
  }

  @override
  void didChangePlatformBrightness() {
    BaseThemeNotifier.changeSystemDark(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route != null && route is PageRoute)
      BaseRouteObserver.instance.subscribe(this, route);
  }

  @override
  void dispose() {
    BaseLifecycleObserver()
        .lifecycleState
        .removeListener(_dealWithAppLifecycle);
    BaseRouteObserver.instance.unsubscribe(this);
    _onStartChange.dispose();
    _onPauseChange.dispose();
    _onResumeChange.dispose();
    super.dispose();
  }

  void _dealWithAppLifecycle() {
    final state = BaseLifecycleObserver().lifecycleState.value;
    switch (state) {
      case AppLifecycleState.detached:
        // 应用任然托管在flutter引擎上,但是不可见.
        // 当应用处于这个状态时,引擎没有视图的运行.要不就是当引擎第一次初始化时处于attach视
        // 要不就是由于导航弹出导致的视图销毁后
        onDestroy();
        break;
      case AppLifecycleState.inactive:
        // 应用在一个不活跃的状态,不会收到input输入
        // 在ios为前台不活跃状态运行.当有电话进来时候应用转到这个状态等
        // 在安卓上外一个activity获得焦点时,应用转到这个状态.比如分屏,电话等
        break;
      case AppLifecycleState.paused:
        //应用当前对于用户不可见,不会响应输入,运行在后台
        onAppPause();
        break;
      case AppLifecycleState.resumed:
        onAppResume();
        break;
      case AppLifecycleState.hidden:
        //paused和inactive转换中都会被响应
        //onAppPause();
        break;
    }
  }

  ///when the current route has been pushed.
  @override
  void didPush() {
    onStart();
  }

  ///when the current route has been popped off.
  @override
  void didPop() {
    onPause();
    onDestroy();
  }

  ///when the top route has been popped off, and the current route shows up.
  @override
  void didPopNext() {
    onResume();
  }

  ///when a new route has been pushed, and the current route is no longer visible.
  @override
  void didPushNext() {
    onPause();
  }

  void onStart() {
    _updateLifecycleState(
        PageLifecycleState.start, () => _onStartChange.notifyListeners());
  }

  void onResume() {
    _updateLifecycleState(PageLifecycleState.resume, () {
      _onResumeChange.notifyListeners();
    });
  }

  void onPause() {
    _updateLifecycleState(PageLifecycleState.pause, () {
      _onPauseChange.notifyListeners();
    });
  }

  /// 页面销毁 原则上重写dispose方法也是一样的
  void onDestroy() {
    _updateLifecycleState(PageLifecycleState.destroy, () {});
  }

  /// 用于绑定viewModel onStart回调 首次绑定直接回调onStart
  void bindStart(Function _onStart) {
    if (!_hasAddStartChange) {
      _hasAddStartChange = true;
      _onStartChange.addListener(() => _onStart());
      _onStartChange.notifyListeners();
    }
  }

  void bindResume(Function onResume) {
    if (!_hasAddResumeChange) {
      _hasAddResumeChange = true;
      _onResumeChange.addListener(() => onResume());
      _onResumeChange.notifyListeners();
    }
  }

  void bindPause(Function _onPause) {
    if (!_hasAddPauseChange) {
      _hasAddPauseChange = true;
      _onPauseChange.addListener(() => _onPause());
    }
  }

  /// 更新页面生命周期并执行代码块逻辑
  void _updateLifecycleState(PageLifecycleState state, Function block) {
    if (_lifecycleState == state) return;
    _lifecycleState = state;
    block();
  }

  /// 应用获取焦点进入前台
  void onAppResume() {
    //BaseClipboardUtil().dealWithClipboard(context);
    if (_isAppPause) {
      _isAppPause = false;
      _updateLifecycleState(PageLifecycleState.resume, () {
        BaseLogUtil().t(tag: widget.toString(), "onAppResume()");
        _onResumeChange.notifyListeners();
      });
    }
  }

  /// 应用失去焦点退至后台
  void onAppPause() {
    // BaseClipboardUtil().isShown = false;
    _updateLifecycleState(PageLifecycleState.pause, () {
      _isAppPause = true;
      BaseLogUtil().t(tag: widget.toString(), "onAppPause()");
      _onPauseChange.notifyListeners();
    });
  }
}

/// 页面生命周期
enum PageLifecycleState { unInitialized, start, pause, resume, destroy }

extension PageStateExtensions on BasePageState {
  /// 创建viewModelWidget树
  /// [create] viewModel构建实例
  /// [viewBuild] widget构建方法
  Widget buildViewModel<T extends BaseNotifier>({
    required Create<T> create,
    required ViewBuild<T> viewBuild,
    PreferredSizeWidget? appBar,
    bool backPress = false, //是否可以使用物理返回
    bool safeArea = true, //是否安全屏
    bool resizeToAvoidBottomInset = true, //是否随键盘移动,false为覆盖true为移动
    bool annotatedRegion = false, //修改状态栏
    Widget? statusView, //状态栏图片
    Color? statusColor, //状态栏颜色
  }) {
    return ChangeNotifierProvider(
      create: create,
      child: Consumer<T>(builder: (context, viewModel, child) {
        vm = viewModel;
        bindStart(() => viewModel.onStart());
        bindPause(() => viewModel.onPause());
        bindResume(() => viewModel.onResume());
        return WillPopScope(
            onWillPop: () async => backPress ? await _exit() : backPress,
            // return PopScope(
            //     canPop: backPress ? false : true,
            //     onPopInvoked: (bool didPop) async {
            //       if (didPop) return;
            //       await _exit();
            //     },
            child: safeArea
                ? annotatedRegion
                    ? _statusView(
                        viewBuild(context, viewModel),
                        appBar,
                        resizeToAvoidBottomInset,
                        annotatedRegion,
                        safeArea,
                        statusView: statusView,
                        statusColor: statusColor,
                      )
                    : SafeArea(
                        child: Scaffold(
                        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                        body: viewBuild(context, viewModel),
                        appBar: appBar ?? null,
                      ))
                : annotatedRegion
                    ? _statusView(
                        viewBuild(context, viewModel),
                        appBar,
                        resizeToAvoidBottomInset,
                        annotatedRegion,
                        safeArea,
                        statusView: statusView,
                        statusColor: statusColor,
                      )
                    : viewBuild(context, viewModel));
      }),
    );
  }

  Future<bool> _exit() async {
    int secondTime = BaseDateUtil.curTimeMS;
    if ((secondTime - firstTime) > limitMillisecond) {
      BaseWidgetUtil.showToast('再按一次退出');
      firstTime = secondTime;
      return false;
    }
    await BaseMCUtil.backDesktop();
    return true;
  }

  Widget _statusView(
    viewModel,
    PreferredSizeWidget? appbar,
    bool resizeToAvoidBottomInset,
    bool annotatedRegion,
    bool? safeArea, {
    Widget? statusView,
    Color? statusColor,
  }) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusView == null && statusColor == null
          ? BaseUIUtil().getTheme().appBarTheme.backgroundColor
          : statusColor ?? BaseColors.trans,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBodyBehindAppBar: true,
        appBar: appbar,
        body: Stack(children: <Widget>[
          if (statusView != null) Positioned.fill(child: statusView!),
          if (safeArea == true)
            SafeArea(
                child: Container(
                    color: BaseUIUtil().getTheme().primaryColor,
                    child: viewModel)),
          if (safeArea != true)
            Container(
                color: BaseUIUtil().getTheme().primaryColor, child: viewModel)
        ]));
  }

  Widget emptyView({String? text, bool isShow = true}) => Visibility(
      visible: isShow,
      child: Container(
          child: Center(
              child: Text(text ?? '目前数据为空',
                  style:
                      BaseUIUtil().getTheme().primaryTextTheme.bodyMedium))));

  Widget errorView({String? text, bool isShow = true}) => Visibility(
      visible: isShow,
      child: Container(
          child: Center(
              child: Text(text ?? '错误',
                  style:
                      TextStyle(fontSize: 14.sp, color: BaseColors.e70012)))));
}
