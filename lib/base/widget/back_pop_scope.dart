import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_date.dart';
import 'package:djqs/base/util/util_methodchannel.dart';
import 'package:flutter/cupertino.dart';

class BaseBackPop extends StatelessWidget {
  final Widget child;
  final int limitMillisecond;
  int firstTime = 0;

  BaseBackPop({
    Key? key,
    required this.child,
    this.limitMillisecond = 2000,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        int secondTime = BaseDateUtil.curTimeMS;
        if ((secondTime - firstTime) > limitMillisecond) {
          BaseWidgetUtil.showToast('再按一次退出');
          firstTime = secondTime;
          return false;
        }
        await BaseMCUtil.backDesktop();
        return true;
      },
      child: child);
}
