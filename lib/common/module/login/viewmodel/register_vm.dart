import 'dart:async';

import 'package:djqs/app/app_const.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/util/util_string.dart';
import 'package:djqs/common/module/login/entity/account_entity.dart';
import 'package:djqs/common/module/login/util/account_service.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/common/module/start/util/agreement_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterVM extends BaseNotifier {
  bool isAgree = false;
  Timer? timer;
  int countdown = 0;

  late final AccountService service;
  late final FocusNode _focusNode;
  late final userTapRecognizer;
  late final privacyTapRecognizer;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordAgainController;
  late final TextEditingController codeController;

  // final BaseSMSUtil smsUtil = BaseSMSUtil();
  String? mobile;

  RegisterVM(super.context);

  @override
  void init() {
    service = AccountService();
    userTapRecognizer = TapGestureRecognizer()
      ..onTap = () => btn_userAgreement();
    privacyTapRecognizer = TapGestureRecognizer()
      ..onTap = () => btn_userPrivacy();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    passwordAgainController = TextEditingController();
    codeController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void onCleared() {}

  void startTimer() {
    countdown = 59;
    notifyListeners();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      countdown == 0 ? (timer?.cancel()) : countdown--;
      notifyListeners();
    });
  }

  bool isCountDown() => (timer?.isActive ?? false);

  void btn_smscode(int type) async {
    if (!checkPhone()) return;
    // smsUtil.observeSMS(callback: (String? code) {
    //   codeController.text = code ?? '';
    // });
    startTimer();
    dynamic? result = await service.sendSmS(phoneController.text, type);
  }

  void btn_register(BuildContext context) async {
    if (!checkRegister()) return;
    checkAgree(callback: () async {
      AccountEntity? entity = await service.register(
          phoneController.text, codeController.text, passwordController.text);
      if (entity != null) await AccountUtil().dealWithLogin(context, entity);
    });
  }

  void checkAgree({Function()? callback}) {
    if (!_check(!isAgree, null)) {
      AgreementUtil(
        baseContext!,
        onNagBtn: () => false,
        onPosBtn: () {
          isAgree = true;
          notifyListeners();
          callback?.call();
        },
      ).showAgreeDialog(isSimple: true);
    } else
      callback?.call();
  }

  void btn_checkAgreement() {
    isAgree = !isAgree;
    notifyListeners();
  }

  void btn_userAgreement() => pagePushH5(
        url: AppConst().H5_AGREEMENT,
        title: '用户协议',
      );

  void btn_userPrivacy() => pagePushH5(
        url: AppConst().H5_PRIVACY,
        title: '隐私协议',
      );

  bool checkPhone() => BaseStrUtil.validateMobile(phoneController.text);

  bool _check(bool value, String? toastStr) {
    if (value) {
      if (toastStr != null) toast(toastStr);
      return false;
    }
    return true;
  }

  bool checkPassword(TextEditingController controller) {
    if (_check(controller.text.isEmpty, '密码不能为空')) if (_check(
        controller.text.length < 6,
        '密码必须超过6位')) if (_check(controller.text.length > 20, '密码不能超过20位'))
      return true;
    return false;
  }

  bool checkPasswordAgain() {
    if (checkPassword(passwordAgainController)) if (_check(
        passwordAgainController.text != passwordController.text, '两次密码不一致'))
      return true;

    return false;
  }

  bool checkCode() => _check(codeController.text.isEmpty, '验证码不能为空');

  bool checkRegister() {
    if (!checkPhone()) return false;
    if (!checkCode()) return false;
    if (!checkPasswordAgain()) return false;
    return true;
  }
}
