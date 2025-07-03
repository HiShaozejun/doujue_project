import 'dart:convert';
import 'dart:typed_data';

import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/ui/base_dialog.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_date.dart';
import 'package:djqs/base/util/util_num.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/module/purse/entity/check_withdrawl_entity.dart';
import 'package:djqs/module/purse/entity/mpqrcode_entity.dart';
import 'package:djqs/module/purse/entity/purse_entity.dart';
import 'package:djqs/module/purse/purse_history_page.dart';
import 'package:djqs/module/purse/util/purse_service.dart';
import 'package:djqs/module/purse/withdrawl_page.dart';
import 'package:flutter/widgets.dart';

class PurseVM extends BaseNotifier {
  final ValueNotifier<String?>? startVN = ValueNotifier<String?>("");
  final ValueNotifier<String?>? endVN = ValueNotifier<String?>("");
  final ValueNotifier<String?>? dayVN = ValueNotifier<String?>(null);

  late final PurseServiceDuo _serviceDuo = PurseServiceDuo();
  PurseEntity? purseEntity;

  PurseVM(super.context);

  @override
  void init() async {
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    startVN?.value = BaseDateUtil.formatYMDHMS(start);
    endVN?.value = BaseDateUtil.formatYMDHMS(end);
  }

  String get withdrawlValue {
    var value = double.tryParse(ObjectUtil.strToZero(purseEntity?.balance))! -
        (purseEntity?.amount ?? 0);
    return value > 0 ? BaseNumUtil.formatNum(value) : '0.00';
  }

  @override
  void onResume() async {
    purseEntity = await _serviceDuo.getPurseData();
    notifyListeners();
  }

  void btn_withdrawl() async {
    BaseWidgetUtil.showLoading();
    CheckWithdrawlEntity? result = await _serviceDuo.checkWithdrawl();
    if (ObjectUtil.isEmptyList(result?.list)) {
      MPQRcodeEntity? entity = await _serviceDuo.getMPQrcode();
      BaseWidgetUtil.cancelLoading();
      if (!ObjectUtil.isEmptyStr(entity?.wxacode)) {
        Uint8List imageBytes = base64Decode(entity!.wxacode!);
        BaseDialogUtil.showCommonDialog(baseContext!,
            title: '保存二维码，使用要提现的微信打开，\n进入小程序，绑定账号后进行提现',
            contentWidget: Image.memory(imageBytes),
            leftBtnStr: null,
            rightBtnStr: '确定');
      }
    } else {
      BaseWidgetUtil.cancelLoading();
      pagePush(WithdrawlPage(withdrawlValue: withdrawlValue));
    }
  }

  void btn_gotoHistory() => pagePush(PurseHistoryPage());

  @override
  void onCleared() {}
}
