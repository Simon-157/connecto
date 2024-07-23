import 'package:connecto/models/user_model.dart';
import 'package:flutter/material.dart';

class UpdateSkillsScreen extends StatefulWidget {
  final UserModel userProfile;

  UpdateSkillsScreen({required this.userProfile});

  @override
  _UpdateSkillsScreenState createState() => _UpdateSkillsScreenState();
}

class _UpdateSkillsScreenState extends State<UpdateSkillsScreen> {
  final _skillController = TextEditingController();
  final _proficiencyController = TextEditingController();

  void _addSkill() {
    if (_skillController.text.isEmpty || _proficiencyController.text.isEmpty)
      return;

    setState(() {
      widget.userProfile.skills?.add(Skill(
        _skillController.text,
        'Intermediate',
        int.parse(_proficiencyController.text),
      ));
      _skillController.clear();
      _proficiencyController.clear();
    });
  }

  @override
  void dispose() {
    _skillController.dispose();
    _proficiencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              style: const TextStyle(color: Colors.black54, fontSize: 16),
              controller: _skillController,
              decoration: InputDecoration(
                labelText: 'Skill',
                labelStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.grey[200],
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(color: Colors.black54, fontSize: 16),
              controller: _proficiencyController,
              decoration: InputDecoration(
                labelText: 'Proficiency',
                labelStyle: const TextStyle(color: Colors.black54),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addSkill,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text(
                'Add Skill',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Skills List:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.black87),
            ),
            const SizedBox(height: 2),
            ListView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: widget.userProfile.skills?.length ?? 0,
              itemBuilder: (context, index) {
                final skill = widget.userProfile.skills![index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.code, color: Colors.white),
                  ),
                  title: Text(skill.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                  subtitle: Text(
                    'Proficiency: ${skill.proficiency}',
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
