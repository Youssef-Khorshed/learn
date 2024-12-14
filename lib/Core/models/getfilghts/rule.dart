class Rule {
  String? category;
  String? maxPenaltyAmount;
  bool? notApplicable;

  Rule({this.category, this.maxPenaltyAmount, this.notApplicable});

  factory Rule.fromJson(Map<String, dynamic> json) => Rule(
        category: json['category'] as String?,
        maxPenaltyAmount: json['maxPenaltyAmount'] as String?,
        notApplicable: json['notApplicable'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'maxPenaltyAmount': maxPenaltyAmount,
        'notApplicable': notApplicable,
      };
}
