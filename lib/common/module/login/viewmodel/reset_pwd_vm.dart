import 'package:djqs/base/net/base_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'register_vm.dart';

class ResetPwdVM extends RegisterVM {
  ResetPwdVM(super.context);

  void btn_resetPWD(BuildContext context) async {
    if (!checkReset()) return;
    FuncEntity result = await service.resetPwd(
        phoneController.text, codeController.text, passwordController.text);
    if (result.isSuccess()) {
      toast("密码重置成功, 请重新登录");
      pagePop();
    }else toast(result.msg??'重置失败');
  }

  bool checkReset() {
    if (!checkPhone()) return false;
    if (!checkCode()) return false;
    if (!checkPassword(passwordController)) return false;
    if (!checkPasswordAgain()) return false;
    return true;
  }
}
