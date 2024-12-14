class Aircraft {
  String? code;

  Aircraft({this.code});

  factory Aircraft.fromJson(Map<String, dynamic> json) => Aircraft(
        code: json['code'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
      };
}
