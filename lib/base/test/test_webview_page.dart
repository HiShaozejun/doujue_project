import 'package:djqs/base/frame/base_empty_notifier.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/base/webview/base_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestWebviewPage extends StatefulWidget {
  TestWebviewPage();

  @override
  _TestWebviewPageState createState() => _TestWebviewPageState();
}

class _TestWebviewPageState
    extends BasePageState<TestWebviewPage, BaseNotifier> {
  late final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length));
  }

  @override
  Widget build(BuildContext context) => buildViewModel<EmptyNotifier>(
      appBar: BaseWidgetUtil.getAppbar(context, 'webview测试'),
      create: (context) => EmptyNotifier(context),
      viewBuild: (context, vm) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: TextField(
                    maxLines: 1,
                    style:
                        BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
                    controller: textController,
                    decoration: InputDecoration(hintText: '输入url地址'),
                  )),
                  BaseWidgetUtil.getButton(
                      color: BaseColors.c828282,
                      text: '浏览',
                      paddingH: 10.w,
                      paddingV: 10.h,
                      onTap: () {
                        setState(() {});
                      })
                ],
              ),
              Expanded(
                  child: ObjectUtil.isEmptyStr(textController.text)
                      ? Container()
                      : BaseWebViewPage(
                          showHeader: true,
                          title: "webview测试",
                          showLeft: true,
                          url: textController.text.toString() ?? '',
                        ))
            ],
          ));
}
