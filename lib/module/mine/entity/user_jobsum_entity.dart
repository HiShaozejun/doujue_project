class UserJobSumEntity {
/*
{
  "apply_total_num": 10
}
*/

  int? applyTotalNum;

  UserJobSumEntity({
    this.applyTotalNum,
  });

  UserJobSumEntity.fromJson(Map<String, dynamic> json) {
    applyTotalNum = json['apply_total_num']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['apply_total_num'] = applyTotalNum;
    return data;
  }
}
