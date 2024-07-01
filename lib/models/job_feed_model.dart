class JobFeed {
  String feedId;
  String creatorId; // can be userId or companyId
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
  Map<String, double>? latlong;

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
    this.latlong,
  });

  factory JobFeed.fromJson(Map<String, dynamic> json) {
    return JobFeed(
      feedId: json['feedId'] as String,
      creatorId: json['creatorId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      postedDate: DateTime.parse(json['postedDate']),
      salaryRange: json['salaryRange'] as String?,
      requirements: json['requirements'] != null
          ? List<String>.from(json['requirements'])
          : null,
      jobType: json['jobType'] as String?,
      companyDetails: json['companyDetails'] as String?,
      companyLogo: json['companyLogo'] as String?,
      backgroundPicture: json['backgroundPicture'] as String?,
      location: json['location'] as String?,
      latlong: json['latlong'] != null
          ? Map<String, double>.from(json['latlong'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedId': feedId,
      'creatorId': creatorId,
      'type': type,
      'title': title,
      'description': description,
      'postedDate': postedDate.toIso8601String(),
      'salaryRange': salaryRange,
      'requirements': requirements,
      'jobType': jobType,
      'companyDetails': companyDetails,
      'companyLogo': companyLogo,
      'backgroundPicture': backgroundPicture,
      'location': location,
      'latlong': latlong,
    };
  }
}
