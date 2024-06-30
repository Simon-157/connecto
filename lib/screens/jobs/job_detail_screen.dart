import 'package:connecto/models/job_feed_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class JobDetailScreen extends StatefulWidget {
  final JobFeed job;

  const JobDetailScreen({Key? key, required this.job}) : super(key: key);

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool showDescription = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: widget.job.backgroundPicture != null
                      ? CachedNetworkImage(
                          imageUrl: widget.job.backgroundPicture!,
                          fit: BoxFit.cover,
                        )
                      : Container(color: Colors.grey),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                    height:
                        50), // Space to push content below the overlapping container
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      JobHeader(job: widget.job),
                      const SizedBox(height: 16.0),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.grey.shade200,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showDescription = true;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                    ),
                                    color: showDescription
                                        ? Colors.white
                                        : Colors.grey.shade200,
                                    boxShadow: showDescription
                                        ? [
                                            const BoxShadow(
                                              color: Colors.black12,
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            )
                                          ]
                                        : [],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0),
                                  child: Center(
                                    child: Text(
                                      'Description',
                                      style: TextStyle(
                                        color: showDescription
                                            ? Colors.blue
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showDescription = false;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, right:5.0 ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0),
                                    ),
                                    color: !showDescription
                                        ? Colors.white
                                        : Colors.grey.shade200,
                                    boxShadow: !showDescription
                                        ? [
                                            const BoxShadow(
                                              color: Colors.black12,
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            )
                                          ]
                                        : [],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0),
                                  child: Center(
                                    child: Text(
                                      'Company',
                                      style: TextStyle(
                                        color: !showDescription
                                            ? Colors.blue
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      showDescription
                          ? JobDescription(description: widget.job.description)
                          : CompanyDetails(
                              companyDetails: widget.job.companyDetails),
                      const SizedBox(height: 16.0),
                      JobRequirements(requirements: widget.job.requirements),
                      const SizedBox(
                          height: 100.0), // Space for the bottom buttons
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top:
                190, 
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    JobHeader(job: widget.job),
                    const SizedBox(height: 16.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey.shade200,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showDescription = true;
                                });
                              },
                              child: Container(
                                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0), 
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                  ),
                                  color: showDescription
                                      ? Colors.white
                                      : Colors.grey.shade200,
                                  boxShadow: showDescription
                                      ? [
                                          const BoxShadow(
                                            color: Colors.black12,
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          )
                                        ]
                                      : [],
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0),
                                child: Center(
                                  child: Text(
                                    'Description',
                                    style: TextStyle(
                                      color: showDescription
                                          ? Colors.blue
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showDescription = false;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 5.0),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(5.0),
                                    bottomRight: Radius.circular(5.0),
                                  ),
                                  color: !showDescription
                                      ? Colors.white
                                      : Colors.grey.shade200,
                                  boxShadow: !showDescription
                                      ? [
                                          const BoxShadow(
                                            color: Colors.black12,
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          )
                                        ]
                                      : [],
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0),
                                child: Center(
                                  child: Text(
                                    'Company',
                                    style: TextStyle(
                                      color: !showDescription
                                          ? Colors.blue
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    showDescription
                        ? JobDescription(description: widget.job.description)
                        : CompanyDetails(
                            companyDetails: widget.job.companyDetails),
                    const SizedBox(height: 16.0),
                    JobRequirements(requirements: widget.job.requirements),
                    const SizedBox(
                        height: 100.0), // Space for the bottom buttons
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16.0, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    // TODO:Implement chat logic 
                  },
                  child: const Icon(Icons.chat),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO:Implement apply logic here
                  },
                  child: const Text('Apply Now'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 15.0),
                    textStyle: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class JobHeader extends StatelessWidget {
  final JobFeed job;

  const JobHeader({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        job.companyLogo != null
            ? CachedNetworkImage(
                imageUrl: job.companyLogo!,
                width: 60.0,
                height: 60.0,
                fit: BoxFit.cover,
              )
            : Container(width: 60.0, height: 60.0, color: Colors.grey),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.title,
                style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 8.0),
              Text(
                job.location ?? 'Location not specified',
                style:
                    const TextStyle(color: Color.fromARGB(255, 181, 230, 191)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class JobDescription extends StatelessWidget {
  final String description;

  const JobDescription({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Job Description',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        ),
        const SizedBox(height: 8.0),
        Text(
          description,
          style: const TextStyle(color: Color.fromARGB(221, 46, 45, 45)),
        ),
      ],
    );
  }
}

class JobRequirements extends StatelessWidget {
  final List<String>? requirements;

  const JobRequirements({Key? key, this.requirements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Requirements',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        ),
        const SizedBox(height: 8.0),
        requirements != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: requirements!
                    .map((requirement) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('• $requirement',
                              style: const TextStyle(
                                  color: Color.fromARGB(221, 46, 45, 45))),
                        ))
                    .toList(),
              )
            : const Text('No specific requirements mentioned.'),
      ],
    );
  }
}

class CompanyDetails extends StatelessWidget {
  final String? companyDetails;

  const CompanyDetails({Key? key, this.companyDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return companyDetails != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Company Details',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 8.0),
              Text(
                companyDetails!,
                style: const TextStyle(color: Color.fromARGB(221, 46, 45, 45)),
              ),
            ],
          )
        : const Text('No company details provided.');
  }
}
