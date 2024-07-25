import 'package:connecto/models/user_model.dart';

final dummyUserProfile = UserModel(
  name: 'Dev Goog',
  bio: 'My name is dev goog. I am a software engineer and I love coding and building stuff.',
  profilePicture: 'https://randomuser.me/api/portraits/men/1.jpg',
  skills: [
    Skill('Web Development', 'Intermediate', 70),
    Skill('UI/UX Design', 'Beginner', 40),
    Skill('Web Development', 'Proficient', 90),
  ],
  demos: [
    Demo(
      'Connecto app',
      'react, node, redux, stripe',
      'https://firebasestorage.googleapis.com/v0/b/connecto-428002.appspot.com/o/sample_video.mp4%20(240p).mp4?alt=media&token=44fd0bed-e198-4703-b344-f8dece291432',
      'https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg',
      10000,
      '3 yrs ago'
    ),
    Demo(
      'Connecto app',
      'react, node, redux, stripe',
      'https://https://firebasestorage.googleapis.com/v0/b/connecto-428002.appspot.com/o/sample_video.mp4%20(240p).mp4?alt=media&token=44fd0bed-e198-4703-b344-f8dece291432',
      'https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg',
      10000,
      '3 yrs ago'
    ),
  ], id: '', userId: '', email: '', address: '', password: '', role: '',
);
