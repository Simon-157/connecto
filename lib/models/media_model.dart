class Media {
  String mediaId;
  String userId;
  String filePath;
  String fileType;
  DateTime timestamp;

  Media({
    required this.mediaId,
    required this.userId,
    required this.filePath,
    required this.fileType,
    required this.timestamp,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      mediaId: json['media_id'],
      userId: json['user_id'],
      filePath: json['file_path'],
      fileType: json['file_type'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'media_id': mediaId,
      'user_id': userId,
      'file_path': filePath,
      'file_type': fileType,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
