import 'package:djqs/base/event/event_bus.dart';
import 'package:djqs/base/event/event_code.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/common/util/common_util_im.dart';
import 'package:djqs/module/message/chat_page.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';

class ChatListVM extends BaseNotifier {
  List<V2TimConversation?>? conversationList;

  ChatListVM(super.context);

  @override
  void init() {}

  @override
  void onResume() {
    getData();
  }

  getData() async {
    V2TimValueCallback<V2TimConversationResult?>? result =
        await CommonIMUtil().getConversationList();
    conversationList = result.data!.conversationList!;
    notifyListeners();
  }

  int _getUnreadCount() {
    int unreadCountTotal = 0;
    for (var item in conversationList!) {
      unreadCountTotal += item!.unreadCount!;
    }
    return unreadCountTotal;
  }

  void btn_onItemClick(V2TimConversation? entity) async {
    await CommonIMUtil().markC2CMessageAsRead(userID: entity?.userID);
    pagePush(ChatPage(title: entity?.showName ?? '', chatId: entity?.userID));
  }

  @override
  void onCleared() {
    EventBus().send(EventCode.MSG_UNREAD_COUNT, _getUnreadCount());
  }
}
