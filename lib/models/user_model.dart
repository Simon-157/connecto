import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String userId;
  String name;
  String email;
  String password;
  String? profilePicture;
  String? bio;
 dynamic skills;
  dynamic location;
  String role;
  String address;

  var userToken;

  UserModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    this.profilePicture,
    this.bio,
    this.skills,
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
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      skills: json['skills'],
      location: json['location'],
      role: json['role'],
      address: json['address'],
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
      'skills': skills,
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
    return UserModel(
      id: doc.id,
      userId: data['user_id'] ?? '', 
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      profilePicture: data['profile_picture'],
      bio: data['bio'],
      skills: data['skills'],
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
      profilePicture: data['profile_picture'],
      bio: data['bio'],
      skills: data['skills'],
      location: data['location'],
      role: data['role'] ?? '',
      address: data['address'] ?? '',
    );
  }
}

