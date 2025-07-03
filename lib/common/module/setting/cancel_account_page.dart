import 'package:djqs/base/frame/base_empty_notifier.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/ui/base_dialog.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/common/module/login/util/account_service.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelAccountPage extends StatefulWidget {
  const CancelAccountPage({Key? key}) : super(key: key);

  @override
  _CancelAccountState createState() => _CancelAccountState();
}

class _CancelAccountState extends BasePageState {
  late final _service = AccountService();

  @override
  Widget build(BuildContext context) => buildViewModel<BaseNotifier>(
      appBar: BaseWidgetUtil.getAppbar(context, "注销账户"),
      create: (context) => EmptyNotifier(context),
      viewBuild: (context, vm) => BaseWidgetUtil.getHorizontalListItem(
          0, NormalListItem(primary: '注销账户'),
          itemHPadding: 15.w,
          divider: Divider(height: 1, color: BaseColors.dad8d8),
          showDivider: true,
          onItemClick: () => btn_onClick()));

  void btn_onClick() => BaseDialogUtil.showCommonDialog(context,
          title: '注销账户', content: '账户注销后将不可以恢复，您确定要注销吗？', onPosBtn: () async {
        //FuncEntity? result = await _service.cancelAccount();
        BaseWidgetUtil.showToast("已申请注销，等待审核中");
        await AccountUtil().logout();
      });
}
