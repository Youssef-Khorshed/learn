class Fee {
  String? amount;
  String? type;

  Fee({this.amount, this.type});

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
        amount: json['amount'] as String?,
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'type': type,
      };
}
