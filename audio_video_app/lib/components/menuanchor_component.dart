import 'package:audio_video_app/screens/audioplayer_screen.dart';
import 'package:audio_video_app/screens/chewieplayer_screen.dart';
import 'package:audio_video_app/screens/youtubeplayer_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuAnchorComponent extends StatelessWidget {
  const MenuAnchorComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => AudioPlayerScreen(),
            ),
            (route) => false,
          ),
          child: Text('audioplayers'),
        ),
        MenuItemButton(
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => YoutubePlayerScreen(),
            ),
            (route) => false,
          ),
          child: Text('youtubeplayer_screen'),
        ),
        MenuItemButton(
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => ChewiePlayerScreen(),
            ),
            (route) => false,
          ),
          child: Text('chewie'),
        ),
      ],
      builder: (context, controller, _) {
        return IconButton(
          onPressed: () =>
              controller.isOpen ? controller.close() : controller.open(),
          icon: Icon(Icons.more_vert),
        );
      },
    );
  }
}
