
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 4),
        Text('${profile.experience} yrs Experience', style: TextStyle(color: Colors.grey[850], fontSize: 14)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: List.generate(5, (index) {
                if (index < profile.rating) {
                  return Icon(Icons.star, color: Colors.amber);
                } else {
                  return Icon(Icons.star, color: Colors.grey);
                }
              }),
            ),
            Icon(Icons.star, color: Colors.amber),

            Text('${profile.rating} Ratings', style: TextStyle(color: Colors.grey[850], fontSize: 14)),
          ],
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text(profile.bio,maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[850], fontSize: 16)),
              SizedBox(height: 8),
            ],
          ),
        ),

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
            Text(skill.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text(skill.level, style: TextStyle(color: Colors.grey[850], fontSize: 14)),
            LinearProgressIndicator(value: skill.proficiency / 100),
            SizedBox(height: 4),
            Text('${skill.proficiency}%', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// class DemoCard extends StatelessWidget {
//   final Demo demo;

//   DemoCard({required this.demo});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Image.network(demo.thumbnailUrl, width: 100, height: 100, fit: BoxFit.cover),
//             SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(demo.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
//                 Text(demo.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[850])),
//                 Text('${demo.views} views', style: TextStyle(color: Colors.grey, fontSize: 12)),
//                 Text(demo.timeAgo, style: TextStyle(color: Colors.grey, fontSize: 12)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
