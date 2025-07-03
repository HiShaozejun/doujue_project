import 'dart:async';

import 'package:djqs/app/app_util.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/net/base_entity.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/base/util/util_string.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/module/purse/entity/check_withdrawl_entity.dart';
import 'package:djqs/module/purse/util/purse_service.dart';
import 'package:flutter/material.dart';

class WithdrawalVM extends BaseNotifier {
  late final PurseService _service = PurseService();
  late final PurseServiceDuo _serviceDuo = PurseServiceDuo();

  late final TextEditingController moneyController = TextEditingController();
  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController codeController = TextEditingController();
  String? withdrawlValue;
  CheckWithdrawlEntity? descEntity;
  bool isAgree = false;
  Timer? timer;
  int countdown = 0;

  WithdrawalVM(super.context, this.withdrawlValue);

  @override
  void init() async {
    descEntity = await _serviceDuo.checkWithdrawl();
  }

  @override
  void onResume() {
    refreshData();
  }

  void refreshData() async {
    await BaseWidgetUtil.showLoading();
    moneyController.clear();
    nameController.clear();
    codeController.clear();
    await BaseWidgetUtil.cancelLoading();
    notifyListeners();
  }

  void btn_onAll() => _updateText(this.withdrawlValue);

  void btn_checkAgreement() {
    isAgree = !isAgree;
    notifyListeners();
  }

  String get phoneStr =>
      BaseStrUtil.getEncryptNumber(AccountUtil().getAccount()?.mobile ?? '');

  void btn_smscode() async {
    if (!isCheck()) return;
    startTimer();
    await _service.sendSmS();
  }

  bool isCountDown() => (timer?.isActive ?? false);

  void startTimer() {
    countdown = 59;
    notifyListeners();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      countdown == 0 ? (timer?.cancel()) : countdown--;
      notifyListeners();
    });
  }

  void _updateText(String? value) {
    moneyController.text = AppUtil().formatYuan(value);
    moneyController.selection = TextSelection.fromPosition(
        TextPosition(offset: moneyController.text.length));
  }

  void btn_onWithdrawal() async {
    if (isCheck(isFinal: true)) {
      FuncEntity? result = await _service.sendWithDrawal(
          moneyController.text, codeController.text, nameController.text);
      if (!ObjectUtil.isEmptyStr(result?.msg)) toast(result!.msg!);
    }
  }

  bool isCheck({bool isFinal = false}) {
    if (double.parse(AppUtil().formatYuan(withdrawlValue)) == 0) {
      toast('您当前可提现的余额不足');
      return false;
    }
    if (ObjectUtil.isEmptyStr(moneyController.text)) {
      toast('请先输入提现金额');
      return false;
    }

    if (isOverRange(double.parse(moneyController.text!))) {
      toast('不能超过可提现金额');
      return false;
    }

    if (ObjectUtil.isEmptyStr(nameController.text)) {
      toast('请先输入用户名');
      return false;
    }

    if (ObjectUtil.isEmptyStr(phoneStr)) {
      toast('提现手机号为空');
      return false;
    }

    if (isFinal) {
      if (ObjectUtil.isEmptyStr(codeController.text)) {
        toast('请输入验证码');
        return false;
      }
      if (isAgree == false) {
        toast('请先查看风险提示并确认继续提现');
        return false;
      }
    }
    return true;
  }

  bool isOverRange(double? amount) {
    if ((amount ?? 0) > (double.parse(AppUtil().formatYuan(withdrawlValue))))
      return true;
    return false;
  }

  @override
  void onCleared() {}
}
