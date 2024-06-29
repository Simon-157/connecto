import 'package:connecto/models/job_feed_model.dart';
import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  final JobFeed job;

  JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          flex: 1,

          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  job.companyLogo!,
                  height: 50.0,
                  width: 50.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        job.companyDetails!,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        job.location!,
                        style: const TextStyle(
                          color: Colors.grey,

                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      job.salaryRange!,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      job.type,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
