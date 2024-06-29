import 'dart:convert';

class JobFeed {
  String feedId;
  String creatorId; //  can be userId or companyId
  String type;
  String title;
  String description;
  DateTime postedDate;
  String? salaryRange;
  List<String>? requirements;
  String? jobType;
  String? companyDetails;
  String? companyLogo;
  String? backgroundPicture;
  String? location;

  JobFeed({
    required this.feedId,
    required this.creatorId,
    required this.type,
    required this.title,
    required this.description,
    required this.postedDate,
    this.salaryRange,
    this.requirements,
    this.jobType,
    this.companyDetails,
    this.companyLogo,
    this.backgroundPicture,
    this.location,
  });

  factory JobFeed.fromJson(Map<String, dynamic> json) {
    // Determine if creator is a User or Company based on JSON structure
    if (json.containsKey('user_id')) {
    } else if (json.containsKey('company_id')) {
    }

    return JobFeed(
      feedId: json['feed_id'],
      creatorId: json['creator_id'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      postedDate: DateTime.parse(json['posted_date']),
      salaryRange: json['salary_range'],
      requirements: json['requirements'] != null
          ? List<String>.from(json['requirements'])
          : null,
      jobType: json['job_type'],
      companyDetails: json['company_details'],
      companyLogo: json['company_logo'],
      backgroundPicture: json['background_picture'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feed_id': feedId,
      'creator_id': creatorId,
      'type': type,
      'title': title,
      'description': description,
      'posted_date': postedDate.toIso8601String(),
      'salary_range': salaryRange,
      'requirements': requirements != null ? jsonEncode(requirements) : null,
      'job_type': jobType,
      'company_details': companyDetails,
      'company_logo': companyLogo,
      'background_picture': backgroundPicture,
      'location': location,
    };
  }
}


