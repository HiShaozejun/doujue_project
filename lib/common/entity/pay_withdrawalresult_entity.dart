class WithdrawalResultEntity {
/*
{
  "tran_sn": "DJ1697613519757053580"
}
*/

  String? tranSn;

  WithdrawalResultEntity({
    this.tranSn,
  });

  WithdrawalResultEntity.fromJson(Map<String, dynamic> json) {
    tranSn = json['tran_sn']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tran_sn'] = tranSn;
    return data;
  }
}
