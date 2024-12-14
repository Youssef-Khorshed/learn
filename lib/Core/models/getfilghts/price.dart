import 'fee.dart';

class Price {
  String? grandTotal;
  String? currency;
  String? total;
  String? base;
  String? tayarrTaxes;
  String? tayarrFees;
  List<Fee>? fees;

  Price({
    this.grandTotal,
    this.currency,
    this.total,
    this.base,
    this.tayarrTaxes,
    this.tayarrFees,
    this.fees,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        grandTotal: json['grandTotal'] as String?,
        currency: json['currency'] as String?,
        total: json['total'] as String?,
        base: json['base'] as String?,
        tayarrTaxes: json['tayarrTaxes'] as String?,
        tayarrFees: json['tayarrFees'] as String?,
        fees: (json['fees'] as List<dynamic>?)
            ?.map((e) => Fee.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'grandTotal': grandTotal,
        'currency': currency,
        'total': total,
        'base': base,
        'tayarrTaxes': tayarrTaxes,
        'tayarrFees': tayarrFees,
        'fees': fees?.map((e) => e.toJson()).toList(),
      };
}
