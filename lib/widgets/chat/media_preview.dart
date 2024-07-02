import 'package:connecto/models/media_model.dart';
import 'package:flutter/material.dart';

class MediaPreview extends StatelessWidget {
  final Media media;

  MediaPreview({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    if (media.fileType == 'image') {
      return Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Image.network(media.filePath, fit: BoxFit.cover),
      );
    } else if (media.fileType == 'video') {
      // TODO: video preview
      return Container();
    } else if (media.fileType == 'audio') {
      // TODO:  audio preview
      return Container();
    } else {
      return Container();
    }
  }
}
