import 'dart:convert';
import 'package:connecto/models/job_feed_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class JobFeedService {
  static const String baseUrl = 'https://connectoapi-production.up.railway.app';

  // Fetch all job feeds
  static Future<List<JobFeed>> fetchJobFeeds() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/jobfeeds'));
      debugPrint(response.body);
      if (response.statusCode == 200) {
        Iterable jsonList = jsonDecode(response.body);
        List<JobFeed> jobFeeds = jsonList.map((model) => JobFeed.fromJson(model)).toList();
        return jobFeeds;
      } else {
        throw HttpException(response.reasonPhrase ??  "", response.statusCode);
      }
    } catch (e) {
      debugPrint('Error fetching job feeds: $e');
      rethrow;
    }
  }

  // Fetch a specific job feed by ID
  static Future<JobFeed> fetchJobFeedById(String feedId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/jobfeeds/$feedId'));
      
      if (response.statusCode == 200) {
        return JobFeed.fromJson(jsonDecode(response.body));
      } else {
        throw HttpException(response.reasonPhrase ?? "", response.statusCode);
      }
    } catch (e) {
      debugPrint('Error fetching job feed by ID: $e');
      rethrow;
    }
  }

  // Create a new job feed
  static Future<JobFeed> createJobFeed(JobFeed jobFeed) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/jobfeeds'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(jobFeed.toJson()),
      );

      if (response.statusCode == 201) {
        return JobFeed.fromJson(jsonDecode(response.body));
      } else {
        throw HttpException(response.reasonPhrase ?? '', response.statusCode);
      }
    } catch (e) {
      debugPrint('Error creating job feed: $e');
      rethrow;
    }
  }

  // Update an existing job feed
  static Future<JobFeed> updateJobFeed(String feedId, JobFeed jobFeed) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/jobfeeds/$feedId'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(jobFeed.toJson()),
      );

      if (response.statusCode == 200) {
        return JobFeed.fromJson(jsonDecode(response.body));
      } else {
        throw HttpException(response.reasonPhrase?? '', response.statusCode);
      }
    } catch (e) {
      debugPrint('Error updating job feed: $e');
      rethrow;
    }
  }

  // Delete a job feed
  static Future<void> deleteJobFeed(String feedId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/jobfeeds/$feedId'));

      if (response.statusCode != 204) {
        throw HttpException(response.reasonPhrase ?? '', response.statusCode);
      }
    } catch (e) {
      debugPrint('Error deleting job feed: $e');
      rethrow;
    }
  }
}

class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException(this.message, this.statusCode);

  @override
  String toString() {
    return 'HttpException: $message (status code: $statusCode)';
  }
}
