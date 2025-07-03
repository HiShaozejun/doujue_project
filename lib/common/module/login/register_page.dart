import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/common/module/login/util/account_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'viewmodel/register_vm.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterState createState() => RegisterState();
}

//abstract class RegisterState<T extends StatefulWidget> extends State<T> {

class RegisterState<T extends RegisterPage, VM extends RegisterVM>
    extends BasePageState<RegisterPage, VM> {
  @override
  Widget build(BuildContext context) => buildViewModel<RegisterVM>(
      resizeToAvoidBottomInset: false,
      appBar: BaseWidgetUtil.getAppbar(context, "注册"),
      create: (context) => RegisterVM(context),
      viewBuild: (context, vm) => _bodyView());

  Widget _bodyView() => Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mobileView(),
          BaseGaps().vGap10,
          smscodeView(),
          BaseGaps().vGap10,
          passwordView(),
          BaseGaps().vGap40,
          BaseWidgetUtil.getBottomButton('注册',
              onPressed: () => vm.btn_register(context),
              includeBottomMargin: false),
          BaseGaps().vGap5,
          agreeView()
        ],
      ));

  Widget mobileView({bool autoFocus = true}) => TextFormField(
        style: BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
        controller: vm.phoneController,
        autofocus: autoFocus,
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11)
        ],
        decoration: getDecoration('请输入手机号', '手机', preStr: '+86 '),
        textInputAction: TextInputAction.next,
        // onEditingComplete: () {
        //   FocusScope.of(context).requestFocus(focusNode);
        // },
      );

  Widget smscodeView({Function()? btn_smscode}) => TextFormField(
        style: BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        controller: vm.codeController,
        decoration: InputDecoration(
          hintMaxLines: 1,
          hintText: '请输入验证码',
          labelText: '验证码',
          suffix: codeWidget(btn_smscode: btn_smscode),
        ),
        textInputAction: TextInputAction.next,
      );

  Widget codeWidget({Function()? btn_smscode}) => InkWell(
        splashColor: BaseColors.trans,
        highlightColor: BaseColors.trans,
        child: Text(vm.isCountDown() ? '${vm.countdown}s' : '发送验证码',
            style: TextStyle(
                color: vm.isCountDown()
                    ? BaseUIUtil().getTheme().primaryTextTheme.bodyMedium!.color
                    : BaseColors.c2872fc,
                fontSize: 14.sp)),
        onTap: vm.isCountDown()
            ? null
            : () =>
                btn_smscode?.call() ??
                vm.btn_smscode(AccountService.SMS_TYPE_REGISTER),
      );

  Widget passwordView({String title = '密码', String hintStr ='请输入密码'}) =>
      TextFormField(
        style: BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
        controller: vm.passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: getDecoration(hintStr, title),
        textInputAction: TextInputAction.done,
      );

  Widget passwordAgainView({String title = '密码', String hintStr = '请再次输入密码'}) =>
      TextFormField(
        style: BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
        controller: vm.passwordAgainController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: getDecoration(hintStr, title),
        textInputAction: TextInputAction.done,
      );

  Widget agreeView() =>
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        InkWell(
          onTap: vm.btn_checkAgreement,
          child: Padding(
              padding: EdgeInsets.only(right: 2.w, top: 5.h, bottom: 5.h),
              child: Icon(
                Icons.check_box,
                color: vm.isAgree ? BaseColors.c2872fc : BaseColors.a4a4a4,
                size: 20.r,
              )),
        ),
        RichText(
          softWrap: true,
          text: TextSpan(
            children: [
              TextSpan(
                text: '我已阅读并同意',
                style: BaseUIUtil().getTheme().textTheme.bodySmall,
              ),
              TextSpan(
                recognizer: vm.userTapRecognizer,
                text: '《用户协议》',
                style: TextStyle(fontSize: 14.sp, color: BaseColors.c2872fc),
              ),
              TextSpan(
                text: '和',
                style: BaseUIUtil().getTheme().textTheme.bodySmall,
              ),
              TextSpan(
                recognizer: vm.privacyTapRecognizer,
                text: '《隐私政策》',
                style: TextStyle(fontSize: 14.sp, color: BaseColors.c2872fc),
              ),
            ],
          ),
        ),
      ]);

  InputDecoration getDecoration(String hitStr, String labelStr, {preStr}) =>
      InputDecoration(
          hintMaxLines: 1,
          prefixText: preStr,
          labelText: labelStr,
          hintText: hitStr);

  @override
  void dispose() {
    super.dispose();
    vm.timer?.cancel();
  }
}
