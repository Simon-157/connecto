import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String userId;
  String name;
  String email;
  String password;
  String? profilePicture;
  String? bio;
  Map<String, dynamic>? skills;
  dynamic location; 
  String role;
  String  address;

  User({
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
    required  this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      skills: jsonDecode(json['skills']),
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
      'skills': jsonEncode(skills),
      'location': location,
      'role': role,
      'address': address,
    };
  }


  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data()! as Map<String, dynamic>)..id = doc.id;
  }

}