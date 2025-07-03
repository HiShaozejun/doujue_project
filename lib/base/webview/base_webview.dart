import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_string.dart';
import 'package:djqs/base/webview/webview_bundledata.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'base_webview_vm.dart';

class BaseWebViewPage extends StatefulWidget {
  String? url;
  String? title;
  bool showHeader;
  bool showLeft;
  bool fromHome;
  bool showDivider;
  Color? appbarColor;
  bool backPress;
  bool? load;

  BaseWVBundleData? wvBundleData;

  BaseWebViewPage(
      {this.url,
      this.title,
      this.showHeader = true,
      this.showLeft = true,
      this.fromHome = false,
      this.wvBundleData,
      this.showDivider = true,
      this.backPress = false,
      this.load = true});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends BasePageState<BaseWebViewPage, BaseWebViewVM> {
  final _key = UniqueKey();

  BaseWebViewVM? webViewVM;

  @override
  void initState() {
    super.initState();
    webViewVM =
        BaseWebViewVM(context, widget.url, widget.load, widget.wvBundleData);
  }

  @override
  Widget build(BuildContext context) => buildViewModel<BaseWebViewVM>(
      create: (BuildContext context) => webViewVM!,
      backPress: widget.backPress,
      appBar: widget.showHeader!
          ? BaseWidgetUtil.getAppbar(context, widget.title,
              showDivider: widget.showDivider, onLeftCilck: () async {
              if (widget.fromHome) {
                // EventBus().send(
                //     EventCode.HOME_TAB_CHANGE, MainTabEvent(isPrevious: true));
              } else
                await vm.goBack();
            }, showLeft: widget.showLeft)
          : null,
      viewBuild: (context, vm) => _bodyView());

  Widget _bodyView() => Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: BaseStrUtil.isUrl(widget.url)
                  ? Stack(
                      children: [
                        WebViewWidget(
                            controller: vm.controller,
                            key: _key,
                            gestureRecognizers: {
                              Factory<VerticalDragGestureRecognizer>(
                                () => VerticalDragGestureRecognizer(),
                              ),
                              // Factory(() => EagerGestureRecognizer()),
                              Factory<LongPressGestureRecognizer>(() =>
                                  LongPressGestureRecognizer()
                                    ..onLongPress = () {}
                                    ..onLongPressStart =
                                        (LongPressStartDetails details) {}),
                            }),
                        if (vm.isLoading) Container()
                      ],
                    )
                  : errorView(text: '地址出错，请访问正确网址'))
        ],
      );

  @override
  void dispose() {
    super.dispose();
  }
}
