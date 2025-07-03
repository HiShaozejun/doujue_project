


class StatTodayEntity {
/*
{
  "orders": "0",
  "trans": "0",
  "graps": "0",
  "distance": 0
}
*/

  String? orders;
  String? trans;
  String? graps;
  int? distance;

  StatTodayEntity({
    this.orders,
    this.trans,
    this.graps,
    this.distance,
  });

  StatTodayEntity.fromJson(Map<String, dynamic> json) {
    orders = json['orders']?.toString();
    trans = json['trans']?.toString();
    graps = json['graps']?.toString();
    distance = json['distance']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['orders'] = orders;
    data['trans'] = trans;
    data['graps'] = graps;
    data['distance'] = distance;
    return data;
  }
}
