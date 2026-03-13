import 'dart:io';

import 'package:audio_video_app/components/menuanchor_component.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ChewiePlayerScreen extends StatefulWidget {
  const ChewiePlayerScreen({super.key});

  @override
  State<ChewiePlayerScreen> createState() => _ChewiePlayerScreenState();
}

class _ChewiePlayerScreenState extends State<ChewiePlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chewie'),
        actions: [MenuAnchorComponent()],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            VideoPlayerComponent(
              url: 'assets/videos/sample_vid.mp4',
              dataSourceType: DataSourceType.asset,
            ),
            SizedBox(height: 20),
            VideoPlayerComponent(
              url:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
              dataSourceType: DataSourceType.network,
            ),
            SizedBox(height: 20),
            SelectVideoComponent(),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerComponent extends StatefulWidget {
  const VideoPlayerComponent({
    super.key,
    required this.url,
    required this.dataSourceType,
  });
  final String url;
  final DataSourceType dataSourceType;

  @override
  State<VideoPlayerComponent> createState() => _VideoPlayerComponentState();
}

class _VideoPlayerComponentState extends State<VideoPlayerComponent> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    switch (widget.dataSourceType) {
      case DataSourceType.asset:
        videoPlayerController = VideoPlayerController.asset(widget.url);
        break;
      case DataSourceType.network:
        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(widget.url));
        break;
      case DataSourceType.file:
        videoPlayerController = VideoPlayerController.file(File(widget.url));
        break;
      case DataSourceType.contentUri:
        videoPlayerController =
            VideoPlayerController.contentUri(Uri.parse(widget.url));
        break;
      default:
        break;
    }
    videoPlayerController.initialize().then(
      (value) {
        setState(() {
          chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            aspectRatio: videoPlayerController.value.aspectRatio,
          );
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.dataSourceType.name.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 16,
          ),
        ),
        videoPlayerController.value.isInitialized
            ? AspectRatio(
                aspectRatio: videoPlayerController.value.aspectRatio,
                child: Chewie(controller: chewieController),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class SelectVideoComponent extends StatefulWidget {
  const SelectVideoComponent({super.key});

  @override
  State<SelectVideoComponent> createState() => _SelectVideoComponentState();
}

class _SelectVideoComponentState extends State<SelectVideoComponent> {
  File? _file;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            XFile? file =
                await ImagePicker().pickVideo(source: ImageSource.gallery);
            if (file != null) {
              setState(() {
                _file = File(file.path);
              });
              print(_file);
            }
          },
          child: Text('Select Video'),
        ),
        if (_file != null)
          VideoPlayerComponent(
            url: _file!.path,
            dataSourceType: DataSourceType.file,
          ),
      ],
    );
  }
}
