import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_string.dart';
import 'package:djqs/common/module/login/util/account_service.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/common/module/login/viewmodel/reset_mobile_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'register_page.dart';

class ResetMobilePage extends RegisterPage {
  @override
  _ResetMobileState createState() => _ResetMobileState();
}

class _ResetMobileState extends RegisterState<ResetMobilePage, ResetMobileVM> {
  @override
  Widget build(BuildContext context) => buildViewModel<ResetMobileVM>(
      resizeToAvoidBottomInset: false,
      appBar: BaseWidgetUtil.getAppbar(context, "更换手机号"),
      create: (context) => ResetMobileVM(context),
      viewBuild: (context, vm) => _bodyView());

  Widget _bodyView() => Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(children: [
                TextSpan(
                    text: '当前已绑定手机号',
                    style: BaseUIUtil().getTheme().primaryTextTheme.displaySmall),
                TextSpan(
                    text: BaseStrUtil.getEncryptNumber(
                        AccountUtil().getAccount()?.mobile ?? ''),
                    style: TextStyle(fontSize: 14.sp,color: BaseColors.f29b2d)),
                TextSpan(
                    text: '换绑后可用新的手机号登录',
                    style: BaseUIUtil().getTheme().primaryTextTheme.displaySmall)
              ])), BaseGaps().vGap10,
          mobileView(),
          BaseGaps().vGap10,
          smscodeView(
              btn_smscode: () =>
                  vm.btn_smscode(AccountService.SMS_TYPE_RESET_MOBILE)),
          BaseGaps().vGap40,
          BaseWidgetUtil.getBottomButton('确定更换',
              onPressed: () => vm.btn_resetMobile(context),
              includeBottomMargin: false),
        ],
      ));
}
