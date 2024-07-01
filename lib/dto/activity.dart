class Activity {
  bool activityCompleted;
  String activityId;
  String activityTitle;
  String description;
  String tourplanId;

  Activity({
    required this.activityCompleted,
    required this.activityId,
    required this.activityTitle,
    required this.description,
    required this.tourplanId,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      activityCompleted: json['activity_completed'] == 1? true : false,
      activityId: json['activity_id'], 
      activityTitle: json['activity_title'], 
      description: json['description'],
      tourplanId: json['tourplan_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_completed': activityCompleted,
      'activity_id': activityId,
      'activity_title': activityTitle,
      'description': description,
      'tourplan_id': tourplanId,
    };
  }
}
