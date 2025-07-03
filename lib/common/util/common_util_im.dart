import 'package:djqs/base/event/event_bus.dart';
import 'package:djqs/base/event/event_code.dart';
import 'package:djqs/base/net/base_service.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_methodchannel.dart';
import 'package:djqs/common/module/login/entity/account_entity.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSimpleMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/history_msg_get_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/log_level_enum.dart';
import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

class CommonIMUtil {
  int imStatus = 0; //1是被踢下来了，聊天的时候要重新登陆下

  late final V2TIMManager _timManager = TencentImSDKPlugin.v2TIMManager;
  late final ImService _service = ImService();

  factory CommonIMUtil() => _instance;
  static late final CommonIMUtil _instance = CommonIMUtil._internal();

  CommonIMUtil._internal() {}

  Future<void> init(int appId) async {
    await initIMSDKAndAddIMListeners(appId);
    await loginIm();
  }

  Future<void> initIMSDKAndAddIMListeners(int appId) async {
    V2TimSimpleMsgListener simpleMsgListener = V2TimSimpleMsgListener(
        onRecvC2CTextMessage: (
      String msgID,
      V2TimUserInfo sender,
      String customData,
    ) {});
    V2TimValueCallback<bool> initRes = await _timManager!.initSDK(
      sdkAppID: appId,
      loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
      listener: V2TimSDKListener(
          onKickedOffline: () => onKickedOffline(),
          onUserSigExpired: () => loginIm(isSigExpired: true)),
    );

    if (initRes.code == 0) {
      //以下监听可按需设置,为防止遗漏消息，请在登录前设置监听。
      _timManager!.addSimpleMsgListener(
        listener: simpleMsgListener,
      );
      _timManager!.getMessageManager().addAdvancedMsgListener(listener:
          V2TimAdvancedMsgListener(onRecvNewMessage: (V2TimMessage value) {
        EventBus().send(EventCode.MSG_CHAT_NEW, value);
      }));
    } else {}
  }

  Future<void> logoutIm() async => await _timManager!.logout();

  Future<bool> loginIm(
      {bool showError = false, bool isSigExpired = false}) async {
    if (!AccountUtil().isHasLogin) return false;
    //
    AccountEntity? accountEntity = AccountUtil().getAccount();
    V2TimCallback? loginResult = await _timManager.login(
      userID: accountEntity?.im?.userId ?? '',
      userSig: accountEntity?.im?.UserSig ?? '',
    );

    if (loginResult == null || loginResult?.code != 0) {
      if (showError) BaseWidgetUtil.showToast('im登录失败');
      return false;
    }
    return true;
  }

  Future<bool> isLogin() async {
    V2TimValueCallback<int> value = await _timManager!.getLoginStatus();
    return value.code == 1 || value.code == 2;
  }

  //被踢下线后的操作
  void onKickedOffline() async {
    try {} catch (err) {}
  }

  void invokeChatActivity(data) async {
    if (imStatus == 1) await loginIm();
  }

  void invokeConversationActivity() async {
    if (imStatus == 1) await loginIm();
  }

  Future<V2TimValueCallback<V2TimConversationResult>> getConversationList(
          {nextSeq = '0', count = 100}) =>
      _timManager!
          .getConversationManager()
          .getConversationList(nextSeq: nextSeq, count: count);

  Future<V2TimValueCallback<List<V2TimMessage>>> getC2CHistoryMessageList({
    String? userID,
    int? count,
    String? lastMsgID,
  }) =>
      _timManager!.getMessageManager().getC2CHistoryMessageList(
          userID: userID!, count: count!, lastMsgID: lastMsgID);

  Future<V2TimValueCallback<List<V2TimMessage>>> getHistoryMessageList({
    HistoryMsgGetTypeEnum getType =
        HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_OLDER_MSG,
    String? userID,
    int? count,
    String? lastMsgID,
  }) =>
      _timManager!.getMessageManager().getHistoryMessageList(
          getType: getType,
          userID: userID,
          count: count!,
          lastMsgID: lastMsgID);

  Future<V2TimValueCallback<V2TimMessage>> sendC2CTextMessage({
    String? text,
    String? userID,
  }) =>
      _timManager!.sendC2CTextMessage(text: text!, userID: userID!);

  Future<V2TimValueCallback<V2TimMessage>> sendImageMessage({
    String? imagePath,
    String? receiver,
    String? groupID = '',
  }) =>
      _timManager!.getMessageManager().sendImageMessage(
          imagePath: imagePath!, receiver: receiver!, groupID: groupID!);

  Future<V2TimCallback> markC2CMessageAsRead({
    String? userID,
  }) =>
      _timManager!.getMessageManager().markC2CMessageAsRead(userID: userID!);

// Future<bool?> isRegisterIM(String? chatId) async {
//   if (chatId == null) return false;
//   return await _service.isRegisterIM(chatId);
// }
}

class ImService extends BaseService {
  // Future<IMEntity?> registerIM() {
  //   return requestSync(
  //       showLoading: false,
  //       path: "${BaseNetConst().passportUrl}/tim/sign",
  //       create: (resource) => IMEntity.fromJson(resource));
  // }
  //
  // Future<bool?> isRegisterIM(String chatid) {
  //   return requestSync(
  //       showLoading: false,
  //       data: {'chatid': chatid},
  //       path: "${BaseNetConst().passportUrl}/tim/sign/check-exists",
  //       create: (resource) => resource);
  // }
}
