class BasePushData {
  static const PUSH_ACTION_TASK = 1000;

/*
{
  "time": "",
  "action": 1000,
  "data": ""
}
*/

  String? time;
  int? action;
  String? data;

  BasePushData({
    this.time,
    this.action,
    this.data,
  });

  BasePushData.fromJson(Map<String, dynamic> json) {
    time = json['time']?.toString();
    action = json['action']?.toInt();
    data = json['data']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['time'] = time;
    data['action'] = action;
    data['data'] = this.data;
    return data;
  }
}
