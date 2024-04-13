const String tableTourPlan = 'tourplan';

class TourPlansField {
  static const String id = '_id';
  static const String header = 'header';
  static const String name = 'name';
  static const String location = 'location';

  static final List<String> values = [id, header, name, location];
}

class TourPlan {
  const TourPlan({
    required this.id,
    required this.header,
    required this.name,
    required this.location,
  });

  final int? id;
  final String? header;
  final String? name;
  final String? location;

  Map<String, Object?> toJson() => {
        TourPlansField.id: id,
        TourPlansField.header: header,
        TourPlansField.name: name,
        TourPlansField.location: location,
      };

  static TourPlan fromJson(
    Map<String, Object?> json,
  ) =>
      TourPlan(
        id: json[TourPlansField.id] as int,
        header: json[TourPlansField.header] as String,
        name: json[TourPlansField.name] as String,
        location: json[TourPlansField.location] as String,
      );

  //
  TourPlan copy({
    int? id,
    String? header,
    String? name,
    String? location,
  }) =>
      TourPlan(
        id: id ?? this.id,
        header: header ?? this.header,
        name: name ?? this.name,
        location: location ?? this.location,
      );
}
