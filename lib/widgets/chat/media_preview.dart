import 'package:connecto/models/media_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

class MediaPreview extends StatefulWidget {
  final Media media;

  const MediaPreview({super.key, required this.media});

  @override
  _MediaPreviewState createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<MediaPreview> {
  late VideoPlayerController _videoController;
  late AudioPlayer _audioPlayer;
  bool _isVideoInitialized = false;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

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
      _audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _duration = duration;
        });
      });
      _audioPlayer.onPositionChanged.listen((position) {
        setState(() {
          _position = position;
        });
      });
      _audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      });
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
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
      return Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  onPressed: () async {
                    if (_isPlaying) {
                      await _audioPlayer.pause();
                    } else {
                      await _audioPlayer.play(UrlSource(widget.media.filePath));
                    }
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                ),
                Text(
                  _formatDuration(_position),
                  style: TextStyle(fontSize: 14),
                ),
                Expanded(
                  child: Slider(
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(position);
                      await _audioPlayer.resume();
                    },
                  ),
                ),
                Text(
                  _formatDuration(_duration),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            if (_isPlaying)
              LinearProgressIndicator(
                value: _position.inSeconds.toDouble() /
                    _duration.inSeconds.toDouble(),
              ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
