import 'package:djqs/base/net/base_entity.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'register_vm.dart';

class ResetMobileVM extends RegisterVM {
  ResetMobileVM(super.context);

  void btn_resetMobile(BuildContext context) async {
    if (!checkReset()) return;
    FuncEntity result =
        await service.resetMobile(phoneController.text, codeController.text);
    if (result.isSuccess()) {
      toast("手机号更换成功，请重新登录");
      AccountUtil().logout();
    } else
      toast("更换失败");
  }

  bool checkReset() {
    if (!checkPhone()) return false;
    if (!checkCode()) return false;
    return true;
  }
}
