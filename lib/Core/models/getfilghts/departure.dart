class Departure {
  String? iataCode;
  String? terminal;
  String? at;

  Departure({this.iataCode, this.terminal, this.at});

  factory Departure.fromJson(Map<String, dynamic> json) => Departure(
        iataCode: json['iataCode'] as String?,
        terminal: json['terminal'] as String?,
        at: json['at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'iataCode': iataCode,
        'terminal': terminal,
        'at': at,
      };
}
