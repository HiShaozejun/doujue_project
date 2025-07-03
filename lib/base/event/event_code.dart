// class BaseEvents<T> {//dart无反射
//   int code = 0;
//   T content;
//
//   BaseEvents(this.code, this.content);
//
//   T getContent() {
//     return content;
//   }
// }

enum EventCode {
  LOCATION_REFRESH,
  MSG_CHAT_NEW,
  WEBVIEW_RELOAD,
  MSG_UNREAD_COUNT,
  HOME_TAB_CHANGE,
  ACCOUNT_CHANGE,
  //
  HOME_BTN_REFRESH,
  HOME_COUNT_REFRESH,
  ORDER_LIST_REFRESH,
  ORDER_ITEM_CHANGE
}
