class Genres {
  final List<Genre> genres;

  Genres({this.genres});

  factory Genres.fromJson(Map<String, dynamic> json) {
    var _genres = json['genres'] as List;
    var _genresObject = _genres.map((i) => Genre.fromJson(i)).toList();
    return Genres(genres: _genresObject);
  }
}

class Genre {
  final int id;
  final String name;

  Genre({this.id, this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
