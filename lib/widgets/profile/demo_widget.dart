import 'package:connecto/utils/dummy.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class DemoCard extends StatelessWidget {
  final Demo demo;

  DemoCard({required this.demo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showVideoPlayer(context, demo.videoUrl);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.network(demo.thumbnailUrl, width: 100, height: 100, fit: BoxFit.cover),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(demo.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text(demo.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[850])),
                  Text('${demo.views} views', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(demo.timeAgo, style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVideoPlayer(BuildContext context, String videoUrl) {
    showDialog(
      context: context,
      builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isFullScreen = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      }).catchError((error) {
        setState(() {
          _errorMessage = error.toString();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black54,
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Demo Player', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            color: Colors.black54,
            icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
            onPressed: () {
              setState(() {
                _isFullScreen = !_isFullScreen;
                if (_isFullScreen) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FullScreenVideoPlayer(controller: _controller),
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Center(
        child: _errorMessage != null
            ? Text('Error: $_errorMessage', style: TextStyle(color: Colors.black54))
            : _controller.value.isInitialized
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            color: Colors.black54,
                            icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                            onPressed: () {
                              setState(() {
                                _controller.value.isPlaying ? _controller.pause() : _controller.play();
                              });
                            },
                          ),
                          IconButton(
                            color: Colors.black54,
                            icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                            onPressed: () {
                              setState(() {
                                _isFullScreen = !_isFullScreen;
                                if (_isFullScreen) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenVideoPlayer(controller: _controller),
                                    ),
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                : CircularProgressIndicator(),
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatelessWidget {
  final VideoPlayerController controller;

  FullScreenVideoPlayer({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
