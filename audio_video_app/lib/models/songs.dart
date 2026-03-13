class Songs {
  final List<Song> _songs = [
    Song(
      title: 'Bogos Binted',
      artist: 'Bogos Binted',
      path: 'bogos binted.mp3',
    ),
    Song(
      title: 'Cat Point Laugh',
      artist: 'Car',
      path: 'cat point laugh.mp3',
    ),
    Song(
      title: 'Vine Boom',
      artist: 'Vine',
      path: 'Vine-boom-sound-effect.mp3',
    ),
  ];

  List<Song> get songs => _songs;

  void toggleIsFav(Song song) {
    song.isFav = !song.isFav;
  }
}

class Song {
  final String title;
  final String artist;
  final String path;
  late bool isFav;

  Song({
    required this.title,
    required this.artist,
    required this.path,
    this.isFav = false,
  });
}
