import 'package:cloud_firestore/cloud_firestore.dart';

class Skill {
  final String name;
  final String level;
  final int proficiency;

  Skill(this.name, this.level, this.proficiency);
}

class Demo {
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final int views;
  final String timeAgo;

  Demo(this.title, this.description, this.videoUrl, this.thumbnailUrl, this.views, this.timeAgo);
}

class UserModel {
  String id;
  String userId;
  String name;
  String email;
  String password;
  String profilePicture;
  String? bio;
  List<Skill>? skills;
  List<Demo>? demos;
  dynamic location;
  String role;
  String address;

  UserModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.profilePicture,
    this.bio,
    this.skills,
    this.demos,
    this.location,
    required this.role,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      profilePicture: json['profile_picture'] ?? '',
      bio: json['bio'],
      skills: (json['skills'] as List<dynamic>?)?.map((skill) => Skill(
        skill['name'] ?? '',
        skill['level'] ?? '',
        skill['proficiency'] ?? 0,
      )).toList(),
      demos: (json['demos'] as List<dynamic>?)?.map((demo) => Demo(
        demo['title'] ?? '',
        demo['description'] ?? '',
        demo['videoUrl'] ?? '',
        demo['thumbnailUrl'] ?? '',
        demo['views'] ?? 0,
        demo['timeAgo'] ?? '',
      )).toList(),
      location: json['location'],
      role: json['role'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'email': email,
      'password': password,
      'profile_picture': profilePicture,
      'bio': bio,
      'skills': skills?.map((skill) => {
        'name': skill.name,
        'level': skill.level,
        'proficiency': skill.proficiency,
      }).toList(),
      'demos': demos?.map((demo) => {
        'title': demo.title,
        'description': demo.description,
        'videoUrl': demo.videoUrl,
        'thumbnailUrl': demo.thumbnailUrl,
        'views': demo.views,
        'timeAgo': demo.timeAgo,
      }).toList(),
      'location': location,
      'role': role,
      'address': address,
    };
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception("Document data was null");
    }
  
    // Helper function to parse skills
    List<Skill> parseSkills(dynamic skillsData) {
      if (skillsData is List<dynamic>) {
        return skillsData.map((skill) => Skill(
          skill['name'] ?? '',
          skill['level'] ?? '',
          skill['proficiency'] ?? 0,
        )).toList();
      }
      return [];
    }
  
    // Helper function to parse demos
    List<Demo> parseDemos(dynamic demosData) {
      if (demosData is List<dynamic>) {
        return demosData.map((demo) => Demo(
          demo['title'] ?? '',
          demo['description'] ?? '',
          demo['videoUrl'] ?? '',
          demo['thumbnailUrl'] ?? '',
          demo['views'] ?? 0,
          demo['timeAgo'] ?? '',
        )).toList();
      }
      return [];
    }
  
    return UserModel(
      id: doc.id,
      userId: data['user_id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      profilePicture: data['profile_picture'] ?? '',
      bio: data['bio'],
      skills: parseSkills(data['skills']),
      demos: parseDemos(data['demos']),
      location: data['location'],
      role: data['role'] ?? '',
      address: data['address'] ?? '',
    );
  }


factory UserModel.fromSnapshot(DocumentSnapshot doc) {
  Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  if (data == null) {
    throw Exception("Document data was null");
  }

  return UserModel(
    id: doc.id,
    userId: data['user_id'] ?? '',
    name: data['name'] ?? '',
    email: data['email'] ?? '',
    password: data['password'] ?? '',
    profilePicture: data['profile_picture'] ?? '',
    bio: data['bio'],
    skills: (data['skills'] as List<dynamic>?)?.map((skill) {
      if (skill is Map<String, dynamic>) {
        return Skill(
          skill['name'] ?? '',
          skill['level'] ?? '',
          skill['proficiency'] ?? 0,
        );
      }
      return null;
    }).whereType<Skill>().toList(),
    demos: (data['demos'] as List<dynamic>?)?.map((demo) {
      if (demo is Map<String, dynamic>) {
        return Demo(
          demo['title'] ?? '',
          demo['description'] ?? '',
          demo['videoUrl'] ?? '',
          demo['thumbnailUrl'] ?? '',
          demo['views'] ?? 0,
          demo['timeAgo'] ?? '',
        );
      }
      return null;
    }).whereType<Demo>().toList(),
    location: data['location'],
    role: data['role'] ?? '',
    address: data['address'] ?? '',
  );
}

}


