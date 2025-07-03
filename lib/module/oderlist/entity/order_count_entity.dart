
class OrderCountEntity {
/*
{
  "type1": "142",
  "type2": "15",
  "type3": "3",
  "type4": "0"
}
*/

  String? type1;
  String? type2;
  String? type3;
  String? type4;

  OrderCountEntity({
    this.type1,
    this.type2,
    this.type3,
    this.type4,
  });
  OrderCountEntity.fromJson(Map<String, dynamic> json) {
    type1 = json['type1']?.toString();
    type2 = json['type2']?.toString();
    type3 = json['type3']?.toString();
    type4 = json['type4']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type1'] = type1;
    data['type2'] = type2;
    data['type3'] = type3;
    data['type4'] = type4;
    return data;
  }
}
