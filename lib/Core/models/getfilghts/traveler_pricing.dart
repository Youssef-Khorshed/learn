import 'fare_details_by_segment.dart';
import 'price.dart';

class TravelerPricing {
  String? travelerId;
  String? fareOption;
  String? travelerType;
  Price? price;
  List<FareDetailsBySegment>? fareDetailsBySegment;

  TravelerPricing({
    this.travelerId,
    this.fareOption,
    this.travelerType,
    this.price,
    this.fareDetailsBySegment,
  });

  factory TravelerPricing.fromJson(Map<String, dynamic> json) {
    return TravelerPricing(
      travelerId: json['travelerId'] as String?,
      fareOption: json['fareOption'] as String?,
      travelerType: json['travelerType'] as String?,
      price: json['price'] == null
          ? null
          : Price.fromJson(json['price'] as Map<String, dynamic>),
      fareDetailsBySegment: (json['fareDetailsBySegment'] as List<dynamic>?)
          ?.map((e) => FareDetailsBySegment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'travelerId': travelerId,
        'fareOption': fareOption,
        'travelerType': travelerType,
        'price': price?.toJson(),
        'fareDetailsBySegment':
            fareDetailsBySegment?.map((e) => e.toJson()).toList(),
      };
}
