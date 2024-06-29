import 'package:connectivity/connectivity.dart';
import 'package:connecto/screens/jobs/job_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:connecto/models/job_feed_model.dart';
import 'package:connecto/utils/data.dart';

class JobFeedScreen extends StatefulWidget {
  @override
  _JobFeedScreenState createState() => _JobFeedScreenState();
}

class _JobFeedScreenState extends State<JobFeedScreen> {
  bool _isConnected = true; 

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
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
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Find Your Great Job',
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          CircleAvatar(
            backgroundImage:
                NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: !_isConnected
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No Internet Connection",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _checkInternetConnection,
                    child: Text("Retry"),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search a Job',
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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
            ),
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
    return  GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailScreen(job: jobFeed),
          ));
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
                  label:
                      Text(jobFeed.type, style: const TextStyle(color: Colors.teal, fontSize: 12)),
                  backgroundColor: Colors.white,),
              const SizedBox(width: 5),
              Chip(
                  label: Text(jobFeed.salaryRange!,
                      style: const TextStyle(color: Colors.teal, fontSize: 12)),
                  backgroundColor: Colors.white),
            ],
          ),
        ],
      ),
    ));
  }
}

class JobCard extends StatelessWidget {
  final JobFeed jobFeed;

  JobCard({required this.jobFeed});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              backgroundColor: Colors.white),
        ],
      ),
    );
  }
}
