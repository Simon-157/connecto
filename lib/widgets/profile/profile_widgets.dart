
import 'package:connecto/utils/dummy.dart';
import 'package:flutter/material.dart';

class UserProfileHeader extends StatelessWidget {
  final UserProfile profile;

  UserProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(profile.avatarUrl),
        ),
        SizedBox(height: 8),
        Text(
          profile.username,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text('${profile.experience} yrs Experience'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.amber),
            Text('${profile.rating} Ratings'),
          ],
        ),
        SizedBox(height: 8),
        Text(profile.bio, textAlign: TextAlign.center),
      ],
    );
  }
}

class SkillCard extends StatelessWidget {
  final Skill skill;

  SkillCard({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(skill.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(skill.level),
            LinearProgressIndicator(value: skill.proficiency / 100),
            SizedBox(height: 4),
            Text('${skill.proficiency}%'),
          ],
        ),
      ),
    );
  }
}

class DemoCard extends StatelessWidget {
  final Demo demo;

  DemoCard({required this.demo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.network(demo.thumbnailUrl, width: 100, height: 100, fit: BoxFit.cover),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(demo.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(demo.description),
                Text('${demo.views} views'),
                Text(demo.timeAgo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
