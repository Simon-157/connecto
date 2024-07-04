import 'package:connecto/models/media_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/src/source.dart';

class MediaPreview extends StatefulWidget {
  final Media media;

  MediaPreview({super.key, required this.media});

  @override
  _MediaPreviewState createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<MediaPreview> {
  late VideoPlayerController _videoController;
  late AudioPlayer _audioPlayer;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.media.fileType == 'video') {
      _videoController = VideoPlayerController.network(widget.media.filePath)
        ..initialize().then((_) {
          setState(() {
            _isVideoInitialized = true;
          });
        });
    } else if (widget.media.fileType == 'audio') {
      _audioPlayer = AudioPlayer();
    }
  }

  @override
  void dispose() {
    if (widget.media.fileType == 'video') {
      _videoController.dispose();
    } else if (widget.media.fileType == 'audio') {
      _audioPlayer.dispose();
    }
    super.dispose();
  }

  void _showFullScreen(BuildContext context, Widget content) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: content,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.media.fileType == 'image') {
      return GestureDetector(
        onTap: () => _showFullScreen(
          context,
          Image.network(widget.media.filePath, fit: BoxFit.cover),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 5.0),
          child: Image.network(widget.media.filePath, fit: BoxFit.cover),
        ),
      );
    } else if (widget.media.fileType == 'video') {
      return GestureDetector(
        onTap: () => _showFullScreen(
          context,
          VideoPlayer(_videoController),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 5.0),
          height: 200,
          child: _isVideoInitialized
              ? VideoPlayer(_videoController)
              : CircularProgressIndicator(),
        ),
      );
    } else if (widget.media.fileType == 'audio') {
      return GestureDetector(
        onTap: () => _showFullScreen(
          context,
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () async {
              await _audioPlayer.play(UrlSource(widget.media.filePath));
            },
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 5.0),
          child: IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () async {
              await _audioPlayer.play(UrlSource(widget.media.filePath));
            },
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
