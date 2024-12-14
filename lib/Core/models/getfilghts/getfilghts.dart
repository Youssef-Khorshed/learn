import 'fare_rules.dart';
import 'itinerary.dart';
import 'price.dart';
import 'pricing_options.dart';
import 'traveler_pricing.dart';

class Getfilghts {
  String? type;
  String? id;
  String? source;
  bool? instantTicketingRequired;
  bool? nonHomogeneous;
  bool? oneWay;
  String? lastTicketingDate;
  String? lastTicketingDateTime;
  int? numberOfBookableSeats;
  List<Itinerary>? itineraries;
  Price? price;
  PricingOptions? pricingOptions;
  List<dynamic>? validatingAirlineCodes;
  List<TravelerPricing>? travelerPricings;
  FareRules? fareRules;

  Getfilghts({
    this.type,
    this.id,
    this.source,
    this.instantTicketingRequired,
    this.nonHomogeneous,
    this.oneWay,
    this.lastTicketingDate,
    this.lastTicketingDateTime,
    this.numberOfBookableSeats,
    this.itineraries,
    this.price,
    this.pricingOptions,
    this.validatingAirlineCodes,
    this.travelerPricings,
    this.fareRules,
  });

  factory Getfilghts.fromJson(Map<String, dynamic> json) => Getfilghts(
        type: json['type'] as String?,
        id: json['id'] as String?,
        source: json['source'] as String?,
        instantTicketingRequired: json['instantTicketingRequired'] as bool?,
        nonHomogeneous: json['nonHomogeneous'] as bool?,
        oneWay: json['oneWay'] as bool?,
        lastTicketingDate: json['lastTicketingDate'] as String?,
        lastTicketingDateTime: json['lastTicketingDateTime'] as String?,
        numberOfBookableSeats: json['numberOfBookableSeats'] as int?,
        itineraries: (json['itineraries'] as List<dynamic>?)
            ?.map((e) => Itinerary.fromJson(e as Map<String, dynamic>))
            .toList(),
        price: json['price'] == null
            ? null
            : Price.fromJson(json['price'] as Map<String, dynamic>),
        pricingOptions: json['pricingOptions'] == null
            ? null
            : PricingOptions.fromJson(
                json['pricingOptions'] as Map<String, dynamic>),
        validatingAirlineCodes:
            json['validatingAirlineCodes'] as List<dynamic>?,
        travelerPricings: (json['travelerPricings'] as List<dynamic>?)
            ?.map((e) => TravelerPricing.fromJson(e as Map<String, dynamic>))
            .toList(),
        fareRules: json['fareRules'] == null
            ? null
            : FareRules.fromJson(json['fareRules'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'source': source,
        'instantTicketingRequired': instantTicketingRequired,
        'nonHomogeneous': nonHomogeneous,
        'oneWay': oneWay,
        'lastTicketingDate': lastTicketingDate,
        'lastTicketingDateTime': lastTicketingDateTime,
        'numberOfBookableSeats': numberOfBookableSeats,
        'itineraries': itineraries?.map((e) => e.toJson()).toList(),
        'price': price?.toJson(),
        'pricingOptions': pricingOptions?.toJson(),
        'validatingAirlineCodes': validatingAirlineCodes,
        'travelerPricings': travelerPricings?.map((e) => e.toJson()).toList(),
        'fareRules': fareRules?.toJson(),
      };
}
