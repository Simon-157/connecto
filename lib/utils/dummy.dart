// dummy_data.dart

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

class UserProfile {
  final String name;
  final String username;
  final int experience;
  final double rating;
  final String bio;
  final String avatarUrl;
  final List<Skill> skills;
  final List<Demo> demos;

  UserProfile({
    required this.name,
    required this.username,
    required this.experience,
    required this.rating,
    required this.bio,
    required this.avatarUrl,
    required this.skills,
    required this.demos,
  });
}

final userProfile = UserProfile(
  name: 'Dev Goog',
  username: '@metgoog',
  experience: 2,
  rating: 4.4,
  bio: 'My name is dev goog. I am a software engineer and I love coding and building stuff.',
  avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
  skills: [
    Skill('Web Development', 'Intermediate', 70),
    Skill('UI/UX Design', 'Beginner', 40),
    Skill('Web Development', 'Proficient', 90),
  ],
  demos: [
    Demo(
      'Connecto app',
      'react, node, redux, stripe',
      'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg',
      10000,
      '3 yrs ago'
    ),
    Demo(
      'Connecto app',
      'react, node, redux, stripe',
      'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg',
      10000,
      '3 yrs ago'
    ),
  ],
);
