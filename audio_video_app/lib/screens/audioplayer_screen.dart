import 'package:audio_video_app/components/menuanchor_component.dart';
import 'package:audio_video_app/models/songs.dart';
import 'package:audio_video_app/screens/youtubeplayer_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.paused;

  late List<Song> songs;
  int songIndex = 0;
  late Song currentSong;
  bool isPlayPressed = false;
  bool isShuffled = false;
  bool isLooping = false;
  int timeProgressed = 0;
  int audioDuration = 0;

  @override
  void initState() {
    super.initState();
    songs = Songs().songs;
    currentSong = songs[songIndex];
    audioPlayer.onPlayerStateChanged.listen(
      (event) => setState(() {
        audioPlayerState = event;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isShuffled && songIndex == 0) {
      shufflePlaylist();
    }
    isPlayPressed ? continueAudio() : null;
    return Scaffold(
      appBar: AppBar(
        title: Text('audioplayers'),
        actions: [
          MenuAnchorComponent(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width - 40,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        currentSong.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        currentSong.artist,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Songs().toggleIsFav(currentSong);
                          setState(() {});
                        },
                        icon: currentSong.isFav
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(Icons.favorite_outline),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Slider.adaptive(
                              thumbColor: Colors.black,
                              value: (timeProgressed / 1000).floorToDouble(),
                              onChanged: (value) => seekToSec(value.toInt()),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text('00:00'),
                            Spacer(),
                            Text('00:00'),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => toggleShuffle(),
                            icon: Icon(
                              Icons.shuffle,
                              size: 32,
                              color: isShuffled ? Colors.black : Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () => skipPreviousAudio(),
                            icon: Icon(
                              Icons.skip_previous,
                              size: 48,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                audioPlayerState == PlayerState.playing
                                    ? pauseAudio()
                                    : playAudio(),
                            icon: Icon(
                              audioPlayerState == PlayerState.playing
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              size: 64,
                              color: audioPlayerState == PlayerState.playing
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () => skipNextAudio(),
                            icon: Icon(
                              Icons.skip_next,
                              size: 48,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () => loopAudio(),
                            icon: Icon(
                              Icons.repeat,
                              size: 32,
                              color: isLooping ? Colors.black : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Playlist',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  var song = songs[index];
                  return Card(
                    child: ListTile(
                      leading: Text('${index + 1}'),
                      title: Text(song.title),
                      subtitle: Text(song.artist),
                      trailing: IconButton(
                        onPressed: () {
                          songIndex = index;
                          audioPlayerState == PlayerState.playing
                              ? pauseAudio()
                              : playAudio();
                        },
                        icon: Icon(
                          audioPlayerState == PlayerState.completed &&
                                  index == songs.length - 1
                              ? Icons.play_arrow
                              : songIndex == index && isPlayPressed
                                  ? Icons.pause
                                  : Icons.play_arrow,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void playAudio() async {
    currentSong = songs[songIndex];
    await audioPlayer.play(AssetSource('audio/${currentSong.path}'));
    isPlayPressed = true;
  }

  void pauseAudio() async {
    await audioPlayer.pause();
    isPlayPressed = false;
  }

  void skipPreviousAudio() {
    songIndex--;
    fixSongIndex();
    playAudio();
  }

  void skipNextAudio() {
    songIndex++;
    fixSongIndex();
    playAudio();
  }

  void fixSongIndex() {
    if (songIndex < 0) {
      songIndex = songs.length - 1;
    } else if (songIndex > songs.length - 1) {
      songIndex = 0;
    }
  }

  void continueAudio() {
    if (audioPlayerState == PlayerState.completed) {
      if (!isLooping && songIndex != songs.length - 1) {
        skipNextAudio();
      } else if (isLooping) {
        skipNextAudio();
      }
    }
  }

  void seekToSec(int sec) {
    Duration position = Duration(seconds: sec);
    audioPlayer.seek(position);
  }

  void loopAudio() {
    isLooping = !isLooping;
    setState(() {});
  }

  void toggleShuffle() {
    isShuffled = !isShuffled;
    setState(() {});
  }

  void shufflePlaylist() {
    songs.shuffle();
    setState(() {});
  }
}
