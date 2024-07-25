import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecto/models/job_applications_model.dart';

class JobApplicationsService {
  final CollectionReference _jobApplicationsCollection = FirebaseFirestore.instance.collection('jobApplications');

  // Create a new job application
  Future<void> addJobApplication(JobApplicationsModel jobApplication) async {
    try {
      await _jobApplicationsCollection.add(jobApplication.toMap());
    } catch (e) {
      throw Exception('Error adding job application: $e');
    }
  }

  // Get all job applications
  Future<List<JobApplicationsModel>> getJobApplications() async {
    try {
      QuerySnapshot querySnapshot = await _jobApplicationsCollection.get();
      return querySnapshot.docs.map((doc) => JobApplicationsModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Error fetching job applications: $e');
    }
  }

  // Get all job applications by user ID
  Future<List<JobApplicationsModel>> getJobApplicationsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _jobApplicationsCollection.where('applicantId', isEqualTo: userId).get();
      return querySnapshot.docs.map((doc) => JobApplicationsModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Error fetching job applications: $e');
    }
  }

  // Get all job applications by job ID
  Future<List<JobApplicationsModel>> getJobApplicationsByJobId(String jobId) async {
    try {
      QuerySnapshot querySnapshot = await _jobApplicationsCollection.where('jobId', isEqualTo: jobId).get();
      return querySnapshot.docs.map((doc) => JobApplicationsModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Error fetching job applications: $e');
    }
  }




  // Get a specific job application by ID
  Future<JobApplicationsModel?> getJobApplicationById(String id) async {
    try {
      DocumentSnapshot docSnapshot = await _jobApplicationsCollection.doc(id).get();
      if (docSnapshot.exists) {
        return JobApplicationsModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error fetching job application: $e');
    }
  }

  // Update a specific job application by ID
  Future<void> updateJobApplication(String id, JobApplicationsModel jobApplication) async {
    try {
      await _jobApplicationsCollection.doc(id).update(jobApplication.toMap());
    } catch (e) {
      throw Exception('Error updating job application: $e');
    }
  }

  // Delete a specific job application by userID and jobId
  Future<void> deleteJobApplication(String userId, String jobId) async {
    try {
      QuerySnapshot querySnapshot = await _jobApplicationsCollection
          .where('applicantId', isEqualTo: userId)
          .where('jobId', isEqualTo: jobId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        await _jobApplicationsCollection.doc(querySnapshot.docs.first.id).delete();
      }
    } catch (e) {
      throw Exception('Error deleting job application: $e');
    }
  }
}
