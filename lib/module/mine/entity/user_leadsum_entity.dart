class UserLeadSumEntity {
/*
{
  "new": 3,
  "processing": 0,
  "complete": 17,
  "abnormal": 986,
  "all": 1187
}
*/

  int? theNew;
  int? processing;
  int? complete;
  int? abnormal;
  int? all;

  UserLeadSumEntity({
    this.theNew,
    this.processing,
    this.complete,
    this.abnormal,
    this.all,
  });

  UserLeadSumEntity.fromJson(Map<String, dynamic> json) {
    theNew = json['new']?.toInt();
    processing = json['processing']?.toInt();
    complete = json['complete']?.toInt();
    abnormal = json['abnormal']?.toInt();
    all = json['all']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['new'] = theNew;
    data['processing'] = processing;
    data['complete'] = complete;
    data['abnormal'] = abnormal;
    data['all'] = all;
    return data;
  }
}
