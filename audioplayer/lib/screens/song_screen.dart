import 'package:audioplayers/audioplayers.dart';
import 'package:capitis_mad2_assignment_4/model/songs.dart';
import 'package:capitis_mad2_assignment_4/screens/playlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_color_builder/image_color_builder.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({
    super.key,
    required this.currentIndex,
    required this.audioPlayerState,
  });

  final int currentIndex;
  final PlayerState audioPlayerState;

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  final List<Song> songs = Songs().songs;
  late Song song;
  int currentIndex = 0;
  int sliderValue = 0;

  final AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.paused;

  Duration? duration;
  Duration? position;
  String durationText = '';
  String positionText = '';
  bool gotFromPlaylist = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    currentIndex = widget.currentIndex;
    //play the song first to get duration and position data
    play();
    stop();
    if (widget.audioPlayerState == PlayerState.playing) {
      play();
    }

    audioPlayer.onPlayerStateChanged.listen(
      (event) => setState(() {
        audioPlayerState = event;
      }),
    );
    audioPlayer.onPositionChanged.listen(
      (event) => setState(() {
        position = event;
        String minutes = position.toString().split('.').first.split(':')[1];
        String seconds = position.toString().split('.').first.split(':')[2];
        positionText = '$minutes:$seconds';
      }),
    );
    audioPlayer.onDurationChanged.listen(
      (event) => setState(() {
        duration = event;
        String minutes = duration.toString().split('.').first.split(':')[1];
        String seconds = duration.toString().split('.').first.split(':')[2];
        durationText = '$minutes:$seconds';
      }),
    );
    audioPlayer.onPlayerComplete.listen(
      (event) => setState(() {
        duration = Duration(milliseconds: 0);
        position = Duration(milliseconds: 0);
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    audioPlayerState == PlayerState.completed ? skipNext() : null;

    return ImageColorBuilder(
      url: 'assets/images/${song.image}',
      builder: (context, image, imageColor) {
        bool isImageColorBright = false;
        if (imageColor != null) {
          isImageColorBright =
              imageColor.computeLuminance() >= 0.5 ? true : false;
        }
        return Scaffold(
          backgroundColor: imageColor,
          appBar: AppBar(
            foregroundColor: isImageColorBright ? Colors.black : Colors.white,
            leading: IconButton(
              onPressed:
                  () => Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(
                      builder:
                          (context) => PlaylistScreen(
                            currentIndex: currentIndex,
                            audioPlayerState: audioPlayerState,
                          ),
                    ),
                    (route) => false,
                  ),
              icon: Icon(Icons.keyboard_arrow_down),
            ),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PLAYING FROM',
                  style: TextStyle(
                    fontSize: 12,
                    color: isImageColorBright ? Colors.black : Colors.white,
                  ),
                ),
                Text(
                  'Playlist',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/images/${song.image}',
                      fit: BoxFit.fitHeight,
                      height: MediaQuery.of(context).size.width - 40,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text(song.name),
                  subtitle: Text(song.artist),
                  textColor: isImageColorBright ? Colors.black : Colors.white,
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitleTextStyle: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Slider(
                  padding: const EdgeInsets.all(0),
                  value:
                      (position != null &&
                              duration != null &&
                              position!.inMilliseconds > 0 &&
                              position!.inMilliseconds <
                                  duration!.inMilliseconds)
                          ? position!.inMilliseconds / duration!.inMilliseconds
                          : 0,
                  onChanged: (value) async {
                    if (duration != null) {
                      int seek = (value * duration!.inMilliseconds).round();
                      await audioPlayer.seek(Duration(milliseconds: seek));
                    }
                  },
                  activeColor: isImageColorBright ? Colors.black : Colors.white,
                  inactiveColor:
                      isImageColorBright ? Colors.white : Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      positionText,
                      style: TextStyle(
                        color: isImageColorBright ? Colors.black : Colors.white,
                      ),
                    ),
                    Text(
                      durationText,
                      style: TextStyle(
                        color: isImageColorBright ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => skipPrevious(),
                      color: isImageColorBright ? Colors.black : Colors.white,
                      icon: Icon(Icons.skip_previous, size: 48),
                    ),
                    IconButton(
                      onPressed:
                          () =>
                              audioPlayerState == PlayerState.playing
                                  ? pause()
                                  : play(),
                      color: isImageColorBright ? Colors.black : Colors.white,
                      icon: Icon(
                        audioPlayerState == PlayerState.playing
                            ? Icons.pause_circle
                            : Icons.play_circle,
                        size: 64,
                      ),
                    ),
                    IconButton(
                      onPressed: () => skipNext(),
                      color: isImageColorBright ? Colors.black : Colors.white,
                      icon: Icon(Icons.skip_next, size: 48),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future resetPlay() async {
    song = songs[currentIndex];
    stop();
    await audioPlayer.play(AssetSource('audio/${song.path}'));
    setState(() {});
  }

  Future play() async {
    position = Duration(milliseconds: 0);
    song = songs[currentIndex];
    await audioPlayer.play(AssetSource('audio/${song.path}'));
    setState(() {});
  }

  Future pause() async {
    await audioPlayer.pause();
  }

  Future stop() async {
    await audioPlayer.stop();
  }

  void skipPrevious() {
    currentIndex > 0 ? currentIndex-- : currentIndex = songs.length - 1;
    resetPlay();
  }

  void skipNext() {
    currentIndex < songs.length - 1 ? currentIndex++ : currentIndex = 0;
    resetPlay();
  }
}
