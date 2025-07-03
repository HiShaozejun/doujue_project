import 'dart:convert';
import 'dart:typed_data';

import 'package:djqs/base/const/base_const.dart';
import 'package:djqs/base/event/event_bus.dart';
import 'package:djqs/base/event/event_code.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/util/util_string.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:djqs/base/webview/webview_bundledata.dart';
import 'package:djqs/common/util/common_util_js_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class BaseWebViewVM extends BaseNotifier {
  late WebViewController controller;
  late WebViewCookieManager cookieManager = WebViewCookieManager();

  String? url;
  bool? load;
  bool isLoading = true;

  BaseWVBundleData? wvBundledata;

  BaseWebViewVM(super.context, this.url, this.load, this.wvBundledata);

  void _event_reload(args) {
    wvBundledata = args;
    if (wvBundledata?.url == this.url) {
      reload();
    }
  }

  @override
  void init() {
    EventBus().on(EventCode.WEBVIEW_RELOAD, _event_reload);
    if (BaseStrUtil.isUrl(url)) {
      _initController();
    }
  }

  void _initController() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(BaseUIUtil().getTheme().primaryColor)
      ..addJavaScriptChannel(
        BaseConst.H5_JS_CHANNEL,
        onMessageReceived: (JavaScriptMessage jsMsg) {
          JSChannelUtil().dealwithMsg(jsMsg.message, wvBundleData: wvBundledata,
              jsCallback: (String? method, dynamic data) {
            runJS(method, data);
          });
        },
      )
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {
          isLoading = true;
        },
        onPageFinished: (String url) {
          isLoading = false;
          notifyListeners();
        },
        onWebResourceError: (WebResourceError error) {
          error.toString();
        },
        onNavigationRequest: (NavigationRequest request) {
          request.toString();
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        //onUrlChange: (UrlChange change) {}, //HarmonyOS不支持
      ));
    if (load == true) controller.loadRequest(Uri.parse(_formatUrl(url ?? '')!));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  String _formatUrl(String url) {
    if (url.contains('?')) {
      url = url + '&platform=${BaseSystemUtil().platform}';
    } else {
      url = url + '?platform=${BaseSystemUtil().platform}';
    }

    return url;
  }

  void reload() => controller?.reload();

  Future<void> runJS(String? method, dynamic data) async {
    data = jsonEncode(data);
    await controller.runJavaScript('$method($data)');
  }

  void onPop() => pagePop();

  @override
  void onCleared() {
    this.toString();
    EventBus().off(EventCode.WEBVIEW_RELOAD, _event_reload);
  }

  @override
  void onResume() {}

  Future<void> goBack() => Future(() async {
        bool canGoBack = await controller.canGoBack();
        if (canGoBack)
          controller.goBack();
        else
          pagePop();
      });

  Future<void> _onAddToCache(BuildContext context) async {
    await controller.runJavaScript(
      'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";',
    );
    if (context.mounted) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('Added a test entry to cache.'),
      // ));
    }
  }

  Future<void> _onListCache() {
    return controller.runJavaScript('caches.keys()'
        // ignore: missing_whitespace_between_adjacent_strings
        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
        '.then((caches) => Toaster.postMessage(caches))');
  }

  Future<void> _onClearCache(BuildContext context) async {
    await controller.clearCache();
    await controller.clearLocalStorage();
    if (context.mounted) {
      //controller.of(context).showSnackBar();
    }
  }

  Future<void> _onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    if (context.mounted) {} //ui
  }

  Future<void> _onNavigationDelegateExample() {
    final String contentBase64 = base64Encode(
      const Utf8Encoder().convert("kNavigationExamplePage"),
    );
    return controller.loadRequest(
      Uri.parse('data:text/html;base64,$contentBase64'),
    );
  }

  Future<void> _onSetCookie() async {
    await cookieManager.setCookie(
      const WebViewCookie(
        name: 'foo',
        value: 'bar',
        domain: 'httpbin.org',
        path: '/anything',
      ),
    );
    await controller.loadRequest(Uri.parse(
      'https://httpbin.org/anything',
    ));
  }

  Future<void> _onDoPostRequest() {
    return controller.loadRequest(
      Uri.parse('https://httpbin.org/post'),
      method: LoadRequestMethod.post,
      headers: <String, String>{'foo': 'bar', 'Content-Type': 'text/plain'},
      body: Uint8List.fromList('Test Body'.codeUnits),
    );
  }

  Future<void> _onLoadLocalFileExample() async {
    final String pathToIndex = await _prepareLocalFile();
    await controller.loadFile(pathToIndex);
  }

  Future<void> _onLoadFlutterAssetExample() {
    return controller.loadFlutterAsset('assets/www/index.html');
  }

  Future<void> _onLoadHtmlStringExample(String htmlStr) {
    return controller.loadHtmlString(htmlStr);
  }

  Future<void> _onTransparentBackground() {
    return controller.loadHtmlString("");
  }

  _getCookieList(String cookies) {
    if (cookies == null || cookies == '""') {
      return null;
    }
    final List<String> cookieList = cookies.split(';');
    return cookieList;
  }

  static Future<String> _prepareLocalFile() async {
    // final String tmpDir = (await getTemporaryDirectory()).path;
    // final File indexFile = File(
    //     <String>{tmpDir, 'www', 'index.html'}.join(Platform.pathSeparator));
    //
    // await indexFile.create(recursive: true);
    // await indexFile.writeAsString(kLocalExamplePage);
    //
    // return indexFile.path;
    return '';
  }
}
