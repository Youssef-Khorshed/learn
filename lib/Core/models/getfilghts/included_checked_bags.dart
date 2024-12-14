class IncludedCheckedBags {
  int? quantity;
  int? weight;
  String? weightUnit;

  IncludedCheckedBags({this.quantity, this.weight, this.weightUnit});

  factory IncludedCheckedBags.fromJson(Map<String, dynamic> json) {
    return IncludedCheckedBags(
      quantity: json['quantity'] as int?,
      weight: json['weight'] as int?,
      weightUnit: json['weightUnit'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'weight': weight,
        'weightUnit': weightUnit,
      };
}
