import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/common/module/login/util/util_account.dart';

//useless
abstract class FuncABEntity {
/*
{
  "code": 0,
  "msg": "登录成功",
  "info": [
    { }
  ]
}
*/

  int? code;
  String? msg;
  dynamic? info;

  FuncABEntity({this.code, this.msg, this.info});

  FuncABEntity.fromJson(Map<String, dynamic> json, {bool isShowMsg = true}) {
    code = json['code']?.toInt();
    msg = json['msg']?.toString();
    if (json['info'] != null) {
      final v = json['info'];
      info = parseInfo(v);
    }

    if (code == BaseNetConst.REQUEST_LOGIN_EXPIRED) {
      AccountUtil().hasLogined(isCanBack: false, callback: () async {});
    } else if (code != 0 && isShowMsg == true)
      BaseWidgetUtil.showToast(msg ?? "");
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;

    toInfo(data);
    return data;
  }

  dynamic parseInfo(data);

  void toInfo(data);
}

class DemoABEntity extends FuncABEntity {
  DemoABEntity.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }

  @override
  void toInfo(data) {
    if (info != null) {
      final v = info;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['info'] = arr0;
    }
  }

  @override
  parseInfo(data) {
    // final arr0 = <T>[];
    // data.forEach((v) {
    //   arr0.add(T.fromJson(v));
    // });
    // return arr0;
  }
}

