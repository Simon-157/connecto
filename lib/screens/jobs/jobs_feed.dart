import 'package:connectivity/connectivity.dart';
import 'package:connecto/services/auth_service.dart';
import 'package:connecto/services/job_feed_service.dart';
import 'package:flutter/material.dart';
import 'package:connecto/screens/jobs/job_detail_screen.dart';
import 'package:connecto/models/job_feed_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JobFeedScreen extends StatefulWidget {
  @override
  _JobFeedScreenState createState() => _JobFeedScreenState();
}

class _JobFeedScreenState extends State<JobFeedScreen> {
  bool _isConnected = true;
  late Future<List<JobFeed>> _jobFeedsFuture;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _jobFeedsFuture = JobFeedService.fetchJobFeeds();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
      });
    } else {
      setState(() {
        _isConnected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/logo.svg'),
          onPressed: () {},
        ),
        title: const Text(
          'Find Your Great Job',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions:  [
          CircleAvatar(
            backgroundImage:
                NetworkImage(_authService.getCurrentUser()?.photoURL ?? 'https://via.placeholder.com/150'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: !_isConnected
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No Internet Connection",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _checkInternetConnection,
                    child: const Text("Retry", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(204, 104, 236, 163))),
                  ),
                ],
              ),
            )
          : FutureBuilder<List<JobFeed>>(
              future: _jobFeedsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingPlaceholder();
                } else if (snapshot.hasError) {
                  return  const Center(child: Text('Failed to load job feeds', style: TextStyle(color: const Color.fromARGB(195, 244, 67, 54))));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No job feeds available', style: TextStyle(color: Color.fromARGB(195, 8, 19, 18))));
                } else {
                  List<JobFeed> jobFeedDataList = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Search a Job',
                            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FilterTile(title: 'All Jobs', isSelected: true),
                              const SizedBox(width: 16),
                              FilterTile(title: 'UI Designer', isSelected: false),
                              const SizedBox(width: 16),
                              FilterTile(title: 'FE Dev', isSelected: false),
                              const SizedBox(width: 16),
                              FilterTile(title: 'PM', isSelected: false),
                              const SizedBox(width: 16),
                              FilterTile(title: 'Graphic', isSelected: false),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Most Popular',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: jobFeedDataList.length,
                            itemBuilder: (context, index) {
                              return PopularJobCard(jobFeed: jobFeedDataList[index]);
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'All Jobs',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: jobFeedDataList.length,
                          itemBuilder: (context, index) {
                            return JobCard(jobFeed: jobFeedDataList[index]);
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlaceholderTextField(),
          const SizedBox(height: 16),
          _buildPlaceholderFilters(),
          const SizedBox(height: 16),
          _buildPlaceholderSectionTitle(),
          const SizedBox(height: 16),
          _buildPlaceholderJobCards(),
          const SizedBox(height: 16),
          _buildPlaceholderSectionTitle(),
          const SizedBox(height: 16),
          _buildPlaceholderJobList(),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTextField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildPlaceholderFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(5, (index) => _buildPlaceholderFilterTile()),
      ),
    );
  }

  Widget _buildPlaceholderFilterTile() {
    return Container(
      width: 80,
      height: 32,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildPlaceholderSectionTitle() {
    return Container(
      width: 100,
      height: 20,
      color: Colors.grey[300],
    );
  }

  Widget _buildPlaceholderJobCards() {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholderJobList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}

class FilterTile extends StatelessWidget {
  final String title;
  final bool isSelected;

  FilterTile({required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.teal : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.teal,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class PopularJobCard extends StatelessWidget {
  final JobFeed jobFeed;

  PopularJobCard({required this.jobFeed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailScreen(job: jobFeed),
          ),
        );
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(jobFeed.companyLogo!, height: 40),
            const SizedBox(height: 8),
            Text(
              jobFeed.title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              jobFeed.location!,
              style: const TextStyle(color: Colors.white70),
            ),
            const Spacer(),
            Row(
              children: [
                Chip(
                  label: Text(jobFeed.type, style: const TextStyle(color: Colors.teal, fontSize: 12)),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 5),
                Chip(
                  label: Text(jobFeed.salaryRange!,
                      style: const TextStyle(color: Colors.teal, fontSize: 12)),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final JobFeed jobFeed;

  JobCard({required this.jobFeed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailScreen(job: jobFeed),
          ),
        );
      },
      child:Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.network(jobFeed.companyLogo!, height: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobFeed.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  jobFeed.location!,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Chip(
            label: Text(jobFeed.type, style: const TextStyle(color: Colors.teal)),
            backgroundColor: Colors.white,
          ),
        ],
      ),
    ));
  }
}
