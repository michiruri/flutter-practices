import 'package:audioplayers/audioplayers.dart';
import 'package:capitis_mad2_assignment_4/model/songs.dart';
import 'package:capitis_mad2_assignment_4/screens/song_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_color_builder/image_color_builder.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({
    super.key,
    this.currentIndex,
    this.audioPlayerState,
  });

  final int? currentIndex;
  final PlayerState? audioPlayerState;

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final List<Song> songs = Songs().songs;
  late Song currentSong;
  int currentIndex = 0;

  final AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.paused;

  Duration? position;
  Duration? duration;

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
    widget.currentIndex != null
        ? currentIndex = widget.currentIndex!
        : currentIndex = 0;
    currentSong = songs[currentIndex];

    play();
    stop();
    if (widget.audioPlayerState == PlayerState.playing) {
      play();
    }

    audioPlayer.onDurationChanged.listen(
      (event) => setState(() {
        duration = event;
      }),
    );

    if (widget.audioPlayerState == PlayerState.playing) {
      play();
    }

    audioPlayer.onPlayerStateChanged.listen(
      (event) => setState(() {
        audioPlayerState = event;
      }),
    );
    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
      // print(position);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    audioPlayerState == PlayerState.completed ? skipNext() : null;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'assets/images/${currentSong.image}',
                          height: MediaQuery.of(context).size.width / 1.5 - 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text('Playlist'),
                      titleTextStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      subtitle: Text(
                        '${Songs().songs.length.toString()} songs',
                      ),
                      trailing: IconButton(
                        padding: const EdgeInsets.all(0),
                        color: Colors.white,
                        onPressed:
                            () =>
                                audioPlayerState == PlayerState.playing
                                    ? pause()
                                    : play(),
                        icon: Icon(
                          audioPlayerState == PlayerState.playing
                              ? Icons.pause_circle
                              : Icons.play_circle,
                          size: 48,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: Songs().songs.length,
                        itemBuilder: (context, index) {
                          var song = Songs().songs[index];
                          return ListTile(
                            onTap: () {
                              currentSong = song;
                              currentIndex = index;
                              resetPlay();
                            },
                            contentPadding: EdgeInsets.all(0),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset('assets/images/${song.image}'),
                            ),
                            title: Text(song.name),
                            titleTextStyle:
                                index == currentIndex
                                    ? TextStyle(fontWeight: FontWeight.bold)
                                    : TextStyle(),

                            subtitle: Text(song.artist),
                            trailing:
                                index == currentIndex
                                    ? Icon(Icons.music_note_rounded)
                                    : null,
                            iconColor: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ImageColorBuilder(
                  url: 'assets/images/${currentSong.image}',
                  builder: (context, image, imageColor) {
                    bool isImageColorBright = false;
                    if (imageColor != null) {
                      isImageColorBright =
                          imageColor.computeLuminance() >= 0.5 ? true : false;
                    }
                    return Card(
                      margin: const EdgeInsets.all(0),
                      color: imageColor,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/${currentSong.image}',
                          ),
                        ),
                        onTap:
                            () => Navigator.of(context)
                                .pushAndRemoveUntil(
                                  CupertinoPageRoute(
                                    builder:
                                        (context) => SongScreen(
                                          currentIndex: currentIndex,
                                          audioPlayerState: audioPlayerState,
                                        ),
                                  ),
                                  (route) => false,
                                )
                                .then((value) => setState(() {})),
                        title: Text(currentSong.name),
                        subtitle: Text(currentSong.artist),
                        titleTextStyle:
                            isImageColorBright
                                ? TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )
                                : TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                        subtitleTextStyle:
                            isImageColorBright
                                ? TextStyle(color: Colors.black)
                                : TextStyle(color: Colors.white),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => skipPrevious(),
                              color:
                                  isImageColorBright
                                      ? Colors.black
                                      : Colors.white,
                              icon: Icon(Icons.skip_previous),
                            ),
                            IconButton(
                              onPressed:
                                  () =>
                                      audioPlayerState == PlayerState.playing
                                          ? pause()
                                          : play(),
                              color:
                                  isImageColorBright
                                      ? Colors.black
                                      : Colors.white,
                              icon: Icon(
                                audioPlayerState == PlayerState.playing
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                            ),
                            IconButton(
                              onPressed: () => skipNext(),
                              color:
                                  isImageColorBright
                                      ? Colors.black
                                      : Colors.white,
                              icon: Icon(Icons.skip_next),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future play() async {
    currentSong = songs[currentIndex];
    await audioPlayer.play(AssetSource('audio/${currentSong.path}'));
    setState(() {});
  }

  Future resetPlay() async {
    currentSong = songs[currentIndex];
    await audioPlayer.play(AssetSource('audio/${currentSong.path}'));
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
