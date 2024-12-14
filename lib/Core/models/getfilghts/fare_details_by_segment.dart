import 'included_checked_bags.dart';

class FareDetailsBySegment {
  String? segmentId;
  String? cabin;
  String? fareBasis;
  String? fareDetailsBySegmentClass;
  bool? isAllotment;
  IncludedCheckedBags? includedCheckedBags;

  FareDetailsBySegment({
    this.segmentId,
    this.cabin,
    this.fareBasis,
    this.fareDetailsBySegmentClass,
    this.isAllotment,
    this.includedCheckedBags,
  });

  factory FareDetailsBySegment.fromJson(Map<String, dynamic> json) {
    return FareDetailsBySegment(
      segmentId: json['segmentId'] as String?,
      cabin: json['cabin'] as String?,
      fareBasis: json['fareBasis'] as String?,
      fareDetailsBySegmentClass: json['class'] as String?,
      isAllotment: json['isAllotment'] as bool?,
      includedCheckedBags: json['includedCheckedBags'] == null
          ? null
          : IncludedCheckedBags.fromJson(
              json['includedCheckedBags'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'segmentId': segmentId,
        'cabin': cabin,
        'fareBasis': fareBasis,
        'class': fareDetailsBySegmentClass,
        'isAllotment': isAllotment,
        'includedCheckedBags': includedCheckedBags?.toJson(),
      };
}
