typedef EventCallback = Function(dynamic arg);

class EventBus {
  EventBus._internal();

  static EventBus _singleton = new EventBus._internal();

  factory EventBus() => _singleton;

  Map _eMap = new Map<Object, List<EventCallback>?>();

  void on(eventName, EventCallback? f) {
    if (eventName == null || f == null) return;
    _eMap[eventName] ??= <EventCallback>[];
    if (_eMap[eventName] != null) {
      _eMap[eventName]!.add(f);
    }
  }

  void off(dynamic eventName, [EventCallback? callback]) {
    //EventCode eventName
    List<EventCallback>? list = _eMap[eventName];
    if (eventName == null || list == null) return;
    if (callback == null) {
      _eMap[eventName] = null;
    } else {
      list.remove(callback);
    }
  }

  void send(dynamic eventName, [dynamic arg]) {
    List<EventCallback>? list = _eMap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (int i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}
