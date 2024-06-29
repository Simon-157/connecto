import 'dart:convert';

class User {
  String userId;
  String name;
  String email;
  String password;
  String? profilePicture;
  String? bio;
  Map<String, dynamic>? skills;
  dynamic location; 
  String role;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    this.profilePicture,
    this.bio,
    this.skills,
    this.location,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      skills: jsonDecode(json['skills']),
      location: json['location'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'password': password,
      'profile_picture': profilePicture,
      'bio': bio,
      'skills': jsonEncode(skills),
      'location': location,
      'role': role,
    };
  }
}
