class StatMonthEntity {
/*
{
  "id": "15",
  "uid": "21",
  "time": "1740758400",
  "orders": "1",
  "transfers": "0",
  "distance": "0",
  "title": "3月",
  "des": ""
}
*/

  String? id;
  String? uid;
  String? time;
  String? orders;
  String? transfers;
  String? distance;
  String? title;
  String? des;

  StatMonthEntity({
    this.id,
    this.uid,
    this.time,
    this.orders,
    this.transfers,
    this.distance,
    this.title,
    this.des,
  });

  StatMonthEntity.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    uid = json['uid']?.toString();
    time = json['time']?.toString();
    orders = json['orders']?.toString();
    transfers = json['transfers']?.toString();
    distance = json['distance']?.toString();
    title = json['title']?.toString();
    des = json['des']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['time'] = time;
    data['orders'] = orders;
    data['transfers'] = transfers;
    data['distance'] = distance;
    data['title'] = title;
    data['des'] = des;
    return data;
  }
}
