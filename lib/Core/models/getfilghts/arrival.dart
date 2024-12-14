class Arrival {
  String? iataCode;
  String? terminal;
  String? at;

  Arrival({this.iataCode, this.terminal, this.at});

  factory Arrival.fromJson(Map<String, dynamic> json) => Arrival(
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
