const String tableTourPlanDetails = 'tourplandetails';

class TourPlanDetailsField {
  static const String id = '_id_detailtp';
  static const String tourPlanID = 'tourPlanID';
  static const String activity = 'activity';
  static const String desc = 'desc';
  static const String detailLocation = 'detail_location';

  static final List<String> values = [id, tourPlanID, activity, desc, detailLocation];
}

class TourPlanDetails {
  const TourPlanDetails({
    required this.id,
    required this.tourPlanID,
    required this.activity,
    required this.desc,
    required this.detailLocation,
  });

  final int? id;
  final int? tourPlanID;
  final String activity;
  final String desc;
  final String detailLocation;

  Map<String, Object?> toJson() => {
        TourPlanDetailsField.id: id,
        TourPlanDetailsField.tourPlanID: tourPlanID,
        TourPlanDetailsField.activity: activity,
        TourPlanDetailsField.desc: desc,
        TourPlanDetailsField.detailLocation: detailLocation,
      };

  static TourPlanDetails fromJson(Map<String, Object?> json) => TourPlanDetails(
        id: json[TourPlanDetailsField.id] as int,
        tourPlanID: json[TourPlanDetailsField.tourPlanID] as int?,
        activity: json[TourPlanDetailsField.activity] as String,
        desc: json[TourPlanDetailsField.desc] as String,
        detailLocation: json[TourPlanDetailsField.detailLocation] as String,
      );

  TourPlanDetails copy({
    int? id,
    int? tourPlanID,
    String? activity,
    String? desc,
    String? detailLocation,
  }) =>
      TourPlanDetails(
        id: id ?? this.id,
        tourPlanID: tourPlanID ?? this.tourPlanID,
        activity: activity ?? this.activity,
        desc: desc ?? this.desc,
        detailLocation: detailLocation ?? this.detailLocation,
      );
}
