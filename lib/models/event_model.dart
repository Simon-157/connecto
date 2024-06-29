class Event {
  String eventId;
  String userId;
  String title;
  String description;
  DateTime startTime;
  DateTime endTime;

  Event({
    required this.eventId,
    required this.userId,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['event_id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'user_id': userId,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
    };
  }
}
