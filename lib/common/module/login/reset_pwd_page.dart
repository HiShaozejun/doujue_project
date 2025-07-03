import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/common/module/login/util/account_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'register_page.dart';
import 'viewmodel/reset_pwd_vm.dart';

class ResetPwdPage extends RegisterPage {
  @override
  _ResetPwdState createState() => _ResetPwdState();
}

class _ResetPwdState extends RegisterState<ResetPwdPage, ResetPwdVM> {
  @override
  Widget build(BuildContext context) => buildViewModel<ResetPwdVM>(
      resizeToAvoidBottomInset: false,
      appBar: BaseWidgetUtil.getAppbar(context, "重置密码"),
      create: (context) => ResetPwdVM(context),
      viewBuild: (context, vm) => _bodyView());

  Widget _bodyView() => Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mobileView(),
          BaseGaps().vGap10,
          smscodeView(btn_smscode:()=>vm.btn_smscode(AccountService.SMS_TYPE_RESET_PWD)),
          BaseGaps().vGap10,
          passwordView(title: '设置密码',hintStr:  '6-20位数字、字母组成'),
          BaseGaps().vGap10,
          passwordAgainView(title: '确认密码'),
          BaseGaps().vGap40,
          BaseWidgetUtil.getBottomButton('重置',
              onPressed: () => vm.btn_resetPWD(context),
              includeBottomMargin: false),
        ],
      ));
}
