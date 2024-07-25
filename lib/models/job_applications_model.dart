import 'dart:convert';

class JobApplicationsModel {
  final String jobId;
  final String creatorId;
  final String applicantId;
  final String applicantName;
  final String applicantPhotoUrl;
  final String status;

  JobApplicationsModel({
    required this.jobId,
    required this.creatorId,
    required this.applicantId,
    required this.applicantName,
    required this.applicantPhotoUrl,
    required this.status,

  });

  JobApplicationsModel copyWith({
    String? jobId,
    String? creatorId,
    String? applicantId,
    String? applicantName,
    String? applicantPhotoUrl,
    String? status,
  }) {
    return JobApplicationsModel(
      jobId: jobId ?? this.jobId,
      creatorId: creatorId ?? this.creatorId,
      applicantId: applicantId ?? this.applicantId,
      applicantName: applicantName ?? this.applicantName,
      applicantPhotoUrl: applicantPhotoUrl ?? this.applicantPhotoUrl,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobId': jobId,
      'creatorId': creatorId,
      'applicantId': applicantId,
      'applicantName': applicantName,
      'applicantPhotoUrl': applicantPhotoUrl,
      'status': status,
    };
  }

  factory JobApplicationsModel.fromMap(Map<String, dynamic> map) {
    return JobApplicationsModel(
      jobId: map['jobId'] as String,
      creatorId: map['creatorId'] as String,
      applicantId: map['applicantId'] as String,
      applicantName: map['applicantName'] as String,
      applicantPhotoUrl: map['applicantPhotoUrl'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory JobApplicationsModel.fromJson(String source) => JobApplicationsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'JobApplicationsModel(jobId: $jobId, creatorId: $creatorId, applicantId: $applicantId, applicantName: $applicantName, applicantPhotoUrl: $applicantPhotoUrl)';
  }

  @override
  bool operator ==(covariant JobApplicationsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.jobId == jobId &&
      other.creatorId == creatorId &&
      other.applicantId == applicantId &&
      other.applicantName == applicantName &&
      other.applicantPhotoUrl == applicantPhotoUrl;
  }

  @override
  int get hashCode {
    return jobId.hashCode ^
      creatorId.hashCode ^
      applicantId.hashCode ^
      applicantName.hashCode ^
      applicantPhotoUrl.hashCode;
  }
}
