import 'package:connecto/models/user_model.dart';

class Company {
  String companyId;
  String name;
  String logoUrl;
  String address;

  Company({
    required this.companyId,
    required this.name,
    required this.logoUrl,
    required this.address,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['company_id'],
      name: json['name'],
      logoUrl: json['logo_url'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'name': name,
      'logo_url': logoUrl,
      'address': address,
    };
  }
}

class Event {
  String eventId;
  String creatorId; //  can be either userId or companyId
  String title;
  String description;
  DateTime startTime;
  DateTime endTime;
  String eventImage;
  dynamic creator; // Can be User or Company

  Event({
    required this.eventId,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.eventImage,
    required this.creator,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    // Determine if creator is a User or Company based on JSON structure
    dynamic creatorObject;
    if (json.containsKey('user_id')) {
      creatorObject = UserModel.fromJson(json);
    } else if (json.containsKey('company_id')) {
      creatorObject = Company.fromJson(json);
    }

    return Event(
      eventId: json['event_id'],
      creatorId: json['creator_id'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      eventImage: json['event_image'],
      creator: creatorObject,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'creator_id': creatorId,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'event_image': eventImage,
      'creator': creator.toJson(),
    };
  }
}