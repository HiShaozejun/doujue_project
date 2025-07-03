import 'package:djqs/base/route/base_util_route.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'base_pagestate.dart';

abstract class BaseNotifier with ChangeNotifier {
  BuildContext? baseContext;
  bool _isDisposed = false;
  bool showEmptyView = false;

  BaseNotifier(this.baseContext) {
    init();
  }

  void setBaseContext(context) {
    this.baseContext = context;
  }

  @override
  void dispose() {
    _isDisposed = true;
    onCleared();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_isDisposed) return;
    super.notifyListeners();
  }

  void init();

  /// viewModel销毁时，销毁在上个页面的onResume执行完毕后才执行
  void onCleared();

  /// 获得焦点显示时回调
  void onStart() {}

  /// 失去焦点隐藏时回调
  void onPause() {}

  /// 恢复页面获得焦点显示时回调
  void onResume() {}

  /// 判断当前持有viewModel的view树是否已经解绑
  bool get isDisposed => _isDisposed;

  /// 执行context函数（一般在viewModel初始化代码方法内调用，通过zero延时达到初始化时期获取路由参数正确）
  void runViewContext(RunViewContext function) {
    Future.delayed(Duration.zero).then((_) async {
      function(baseContext!);
    });
  }

  // 延时执行context函数  [duration] 延时时长  [function] 执行函数
  void runViewContextDelay(RunViewContext function, {Duration? duration}) {
    Future.delayed(duration ?? const Duration(milliseconds: 100))
        .then((_) async {
      function(baseContext!);
    });
  }

  BuildContext _getContext(BuildContext? context) => context ?? baseContext!;

  Future<dynamic?> pagePush(page, {BuildContext? context}) =>
      BaseRouteUtil.push(_getContext(context), page);

  Future<dynamic?> pagePushNamed(routeName, {BuildContext? context}) =>
      BaseRouteUtil.pushNamed(_getContext(context), routeName);

  Future<dynamic?> pagePushAndRemoveUntil(page,
          {BuildContext? context, String? endRouterName}) =>
      BaseRouteUtil.pushAndRemoveUntil(_getContext(context), page,
          endRouterName: endRouterName);

  void pagePopUntil(String endRouterName, {BuildContext? context}) =>
      BaseRouteUtil.popUntil(_getContext(context), endRouterName);

  Future<dynamic?> pagePushH5(
          {String? url,
          String? title,
          bool showHeader = true,
          bool showLeft = true,
          BuildContext? context}) =>
      BaseRouteUtil.pushH5(
        _getContext(context),
        url: url,
        title: title,
        showHeader: showHeader,
        showLeft: showLeft,
      );

  void pagePop({params, BuildContext? context}) =>
      BaseRouteUtil.pop(_getContext(context), params: params);

  Future<dynamic?> pagePushReplacement(page, {BuildContext? context}) =>
      BaseRouteUtil.pushReplacement(_getContext(context), page);

  void btn_onBack({BuildContext? context}) => pagePop(context: context);

  Future<bool?> toast(String str,
          {ToastGravity gravity = ToastGravity.BOTTOM}) =>
      BaseWidgetUtil.showToast(str, gravity: gravity);
}

/// 执行带context的函数，可用于延时执行等跨作用域函数
typedef RunViewContext = Function(BuildContext context);

/// PageState build widget时创建viewModel
typedef ViewBuild<T extends BaseNotifier> = Widget Function(
    BuildContext context, T viewModel);

/// PageState 向下传递时在内部构建 viewModel时用到
typedef StateBuild<T extends BasePageState> = Widget Function(
    T state, BuildContext context);
