import 'package:connecto/screens/profile/profile_screen.dart';
import 'package:connecto/services/job_application_service.dart';
import 'package:flutter/material.dart';
import 'package:connecto/models/job_applications_model.dart';

class JobApplicantsScreen extends StatefulWidget {
  final String jobId;

  JobApplicantsScreen({required this.jobId});

  @override
  _JobApplicantsScreenState createState() => _JobApplicantsScreenState();
}

class _JobApplicantsScreenState extends State<JobApplicantsScreen> {
  late Future<List<JobApplicationsModel>> _applicantsFuture;

  @override
  void initState() {
    super.initState();
    _applicantsFuture = JobApplicationsService().getJobApplicationsByJobId(widget.jobId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applicants for Job ${widget.jobId}', style: const TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder<List<JobApplicationsModel>>(
        future: _applicantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.black)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No applicants found.', style: TextStyle(color: Colors.black)));
          } else {
            final applicants = snapshot.data!;
            return ListView.builder(
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                final applicant = applicants[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(userId: applicant.applicantId),
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(applicant.applicantPhotoUrl),
                    ),
                    title: Text(applicant.applicantName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    subtitle: Text('Status: ${applicant.status}', style: const TextStyle(color: Colors.grey)),
                    trailing: Text(
                      applicant.status,
                      style: TextStyle(
                        color: applicant.status == 'Accepted' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
