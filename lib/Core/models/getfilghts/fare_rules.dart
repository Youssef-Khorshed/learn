import 'rule.dart';

class FareRules {
  List<Rule>? rules;

  FareRules({this.rules});

  factory FareRules.fromJson(Map<String, dynamic> json) => FareRules(
        rules: (json['rules'] as List<dynamic>?)
            ?.map((e) => Rule.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'rules': rules?.map((e) => e.toJson()).toList(),
      };
}
