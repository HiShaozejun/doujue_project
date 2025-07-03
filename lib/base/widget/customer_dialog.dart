import 'package:djqs/base/extensions/function_extensions.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:flutter/material.dart';

/// @description 通用弹窗容器
class BaseDialog extends StatefulWidget {
  final double width;
  final double height;
  final bool isCancel;
  final Function? onDismiss;
  final StateBuild stateBuild;

  const BaseDialog(
      {Key? key,
      required this.width,
      required this.height,
      this.isCancel = false,
      this.onDismiss,
      required this.stateBuild})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BaseDialogState();
}

class _BaseDialogState extends BasePageState<BaseDialog, BaseNotifier> {
  @override
  void dispose() {
    widget.onDismiss.checkNullInvoke();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      child: GestureDetector(
          onTap: () => widget.isCancel ? Navigator.of(context).pop() : {},
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                  child: GestureDetector(
                      onTap: () => {},
                      child: Container(
                          width: widget.width,
                          height: widget.height,
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: widget.stateBuild(this, context)))))),
      onWillPop: () async => widget.isCancel);
}
