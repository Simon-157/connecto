import 'package:connecto/models/job_feed_model.dart';
import 'package:connecto/models/user_model.dart';
import 'package:connecto/utils/constants.dart';
import 'package:flutter/material.dart';

class FoundFeedModal extends StatelessWidget {
  final List<JobFeed> jobFeeds;
  final List<UserModel> mentors;

  FoundFeedModal({
    required this.jobFeeds,
    required this.mentors,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20,),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Constants.accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const Center(

              child: Text(
                'Found Feed',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Jobs Section
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
            child: Text(
              'Jobs in this Location',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 36, 58, 54)),
            ),
          ),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: jobFeeds.length,
              itemBuilder: (context, index) {
                JobFeed jobFeed = jobFeeds[index];
                return _buildJobCard(jobFeed);
              },
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 5,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          // Mentors Section
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text(
              'Mentors',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 36, 58, 54)),
            ),
          ),
          Container(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mentors.length,
              itemBuilder: (context, index) {
                UserModel mentor = mentors[index];
                return _buildMentorCard(mentor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(JobFeed jobFeed) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Image.network(
              jobFeed.backgroundPicture ?? '',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jobFeed.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    jobFeed.companyDetails ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () {
                      // to view job button press
                    },
                    child: const Text('View Job'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Constants.accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildMentorCard(UserModel mentor) {
  return Container(
    width: 182,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          mentor.profilePicture.isNotEmpty
              ? Image.network(
                  mentor.profilePicture,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                )
              : Container(
                  color: Colors.grey,
                  height: double.infinity,
                  width: double.infinity,
                ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mentor.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  mentor.role,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    ElevatedButton(
      onPressed: () {
        // TODO: view mentor button press
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(5), 
        foregroundColor: Colors.white,
        backgroundColor: Constants.accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text('View', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
    ),
    const SizedBox(width: 5),
    ElevatedButton(
      onPressed: () {
       
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(5), 
        foregroundColor: Colors.white,
        backgroundColor: Constants.accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text('Connect', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
    ),
  ],
),

              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}