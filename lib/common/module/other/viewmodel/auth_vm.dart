import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/util/util_clipboard.dart';
import 'package:djqs/base/util/util_encrypt.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/common/module/other/entity/oauth_code_entity.dart';
import 'package:djqs/common/module/other/util/other_service.dart';
import 'package:djqs/common/util/common_util_auth_host.dart';

class AuthVM extends BaseNotifier {
  AuthEntity? authEntity;

  AuthVM(super.context, this.authEntity);

  late final OtherService _service = OtherService();

  @override
  void init() async {}

  @override
  void onCleared() {}

  void btn_onNeg() => _dealWithFinish();

  void btn_onPos() async {
    OauthCodeEntity? entity = await _service.oauth(
        authEntity?.cliendId, AccountUtil().getAccount()?.token);
    authEntity?.code = entity?.code;
    _dealWithFinish();
  }

  void _dealWithFinish() async {
    await BaseClipboardUtil()
        .setClipboard(BaseEncryptUtil.encryptMap(authEntity!.toJson()));
    await Future.delayed(Duration(milliseconds: 500));
    BaseSystemUtil().exitApp();
  }
}
