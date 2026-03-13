class Songs {
  List<Song> songs = [
    Song(
      name: 'Crime and Punishment',
      artist: 'Ado',
      path: 'ado_crime and punishment.mp3',
      image: 'ado_crime and punishment.png',
    ),
    Song(name: ':3', artist: 'Tanger', path: 'tanger.mp3', image: 'tanger.jpg'),
    Song(
      name: 'Worki\'n Hard',
      artist: 'Fuji Kaze',
      path: 'fuji kaze_workin hard.mp3',
      image: 'fuji kaze_workin hard.png',
    ),
    Song(
      name: 'Rainy Boots',
      artist: 'inabakumori',
      path: 'inabakumori_rainy boots.mp3',
      image: 'inabakumori_rainy boots.jpg',
    ),
    Song(
      name: 'no flowers',
      artist: 'phendste',
      path: 'phendste_no flowers.mp3',
      image: 'phendste_no flowers.jpg',
    ),
    Song(
      name: 'I Don\t Want to Set the World on Fire',
      artist: 'The Ink Spots',
      path: 'the ink spots_i dont want to set the world on fire.mp3',
      image: 'the ink spots_i dont want to set the world on fire.jpg',
    ),
    Song(
      name: 'Flower',
      artist: 'Johnny Stimson',
      path: 'johnny stimson_flower.mp3',
      image: 'johnny stimson_flower.jpg',
    ),
  ];
}

class Song {
  final String name;
  final String artist;
  final String path;
  final String image;

  Song({
    required this.name,
    required this.artist,
    required this.path,
    required this.image,
  });
}
