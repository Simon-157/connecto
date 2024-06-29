class JobFeed {
  String feedId;
  String userId;
  String type;
  String title;
  String description;
  DateTime postedDate;

  JobFeed({
    required this.feedId,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.postedDate,
  });

  factory JobFeed.fromJson(Map<String, dynamic> json) {
    return JobFeed(
      feedId: json['feed_id'],
      userId: json['user_id'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      postedDate: DateTime.parse(json['posted_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feed_id': feedId,
      'user_id': userId,
      'type': type,
      'title': title,
      'description': description,
      'posted_date': postedDate.toIso8601String(),
    };
  }
}
