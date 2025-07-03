import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/common/module/login/entity/account_entity.dart';
import 'package:djqs/common/module/login/register_page.dart';
import 'package:djqs/common/module/login/reset_pwd_page.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/common/module/setting/setting_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'register_vm.dart';

class LoginVM extends RegisterVM {
  static const int LOGIN_TYPE_PASSWORD = 0;
  static const int LOGIN_TYPE_SMS = 1;

  late final registerTapRecognizer;
  TabController? tabController;

  LoginVM(super.context);

  @override
  void init() {
    super.init();
    registerTapRecognizer = TapGestureRecognizer()
      ..onTap = () => btn_gotoRegister();
  }

  void btn_gotoRegister() async {
    //注册后自动登录
    await pagePush(RegisterPage());
    if (AccountUtil().isHasLogin) pagePop();
  }

  void btn_gotoResetPwd() => pagePush(ResetPwdPage());

  void btn_login(BuildContext context) async {
    if (tabController == null) tabController = DefaultTabController.of(context);

    if (!checkLogin(tabController!.index)) return;

    checkAgree(callback: () async {
      BaseWidgetUtil.showLoading();
      AccountEntity? entity;
      if (tabController!.index == LOGIN_TYPE_PASSWORD)
        entity = (await service.loginWithPW(
            phoneController.text, passwordController.text))?[0];

      if (tabController!.index == LOGIN_TYPE_SMS)
        entity = (await service.loginWithSMS(
          phoneController.text,
          codeController.text,
        ))?[0];

      _dealWithLogin(context, entity);
    });
  }

  void _dealWithLogin(BuildContext context, AccountEntity? entity) async {
    if (entity != null && entity?.id != null)
      await AccountUtil().dealWithLogin(context, entity);
    BaseWidgetUtil.cancelLoading();
  }

  bool checkLogin(int type) {
    if (!checkPhone()) return false;
    if (tabController!.index == LOGIN_TYPE_PASSWORD) {
      if (!checkPassword(passwordController)) return false;
    }
    if (tabController!.index == LOGIN_TYPE_SMS) {
      if (!checkCode()) return false;
    }
    return true;
  }

  void btn_gotoSetting() => pagePush(SettingPage()); //testpegion

  @override
  void dispose() {
    super.dispose();
    // tabController?.dispose(); //dealWithLogin中已经pop了
  }
}
