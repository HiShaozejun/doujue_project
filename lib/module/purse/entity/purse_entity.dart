class PurseEntity {
/*
{
  "balance": "96.55",
  "balancetotal": "96.55",
  "today_income": "5.00",
  "amount": 0
}
*/

  String? balance;
  String? balancetotal;
  String? todayIncome;
  double? amount;
  String? totalIncome;
  String? totalExpense;
  String? unsettledIncome;

  PurseEntity({
    this.balance,
    this.balancetotal,
    this.todayIncome,
    this.amount,
    this.totalIncome,
    this.totalExpense,
    this.unsettledIncome,
  });

  PurseEntity.fromJson(Map<String, dynamic> json) {
    balance = json['balance']?.toString();
    balancetotal = json['balancetotal']?.toString();
    todayIncome = json['today_income']?.toString();
    amount = json['amount']?.toDouble();
    totalIncome = json['total_income']?.toString();
    totalExpense = json['total_expense']?.toString();
    unsettledIncome = json['unsettled_income']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['balance'] = balance;
    data['balancetotal'] = balancetotal;
    data['today_income'] = todayIncome;
    data['amount'] = amount;
    data['total_income'] = totalIncome;
    data['total_expense'] = totalExpense;
    data['unsettled_income'] = unsettledIncome;
    return data;
  }
}
