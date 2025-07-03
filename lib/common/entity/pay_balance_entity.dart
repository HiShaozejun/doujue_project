class PayBalanceEntity {
/*
{
  "amount": "-3.69",
  "fen_amount": "-369"
}
*/

  String? amount;
  String? fenAmount;

  PayBalanceEntity({
    this.amount,
    this.fenAmount,
  });

  PayBalanceEntity.fromJson(Map<String, dynamic> json) {
    amount = json['amount']?.toString();
    fenAmount = json['fen_amount']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['amount'] = amount;
    data['fen_amount'] = fenAmount;
    return data;
  }
}
