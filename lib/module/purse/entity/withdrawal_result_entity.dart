class WithdrawalResultEntity {
  static const PAY_TYPE_WX=2;
/*
{
  "balance": "96.00"
}
*/

  String? balance;

  WithdrawalResultEntity({
    this.balance,
  });

  WithdrawalResultEntity.fromJson(Map<String, dynamic> json) {
    balance = json['balance']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['balance'] = balance;
    return data;
  }
}
