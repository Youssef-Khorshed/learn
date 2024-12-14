class Operating {
  String? carrierCode;

  Operating({this.carrierCode});

  factory Operating.fromJson(Map<String, dynamic> json) => Operating(
        carrierCode: json['carrierCode'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'carrierCode': carrierCode,
      };
}
