class MovieResult {
  bool adult;
  String backdrop_path;
  final List<MovieGenreIds> genre_ids;
  int id;
  String original_language;
  String original_title;
  String overview;
  double popularity;
  String poster_path;
  String release_date;
  String title;
  bool video;
  double voteAverage;
  int vote_count;

  MovieResult(
      {this.adult,
      this.backdrop_path,
      this.id,
      this.original_language,
      this.original_title,
      this.overview,
      this.popularity,
      this.poster_path,
      this.release_date,
      this.title,
      this.video,
      this.vote_count,
      this.genre_ids,
      this.voteAverage});

  factory MovieResult.fromJson(Map<String, dynamic> json) {
    String baseUrl = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2";
    var _genres = json['genre_ids'] as List;
    var upcomingGenreIds =
        _genres.map((i) => MovieGenreIds.fromJson(i)).toList();
    var posterPath = json['poster_path'] as String;
    var backdropPath = json['backdrop_path'] as String;

    String ratedata = json['vote_average'].toString();
    print("asdasdasdasd::: " + ratedata);
    double rate = double.tryParse(ratedata);

    return MovieResult(
        adult: json['adult'] as bool,
        backdrop_path: backdropPath,
        id: json['id'] as int,
        original_language: json['original_language'] as String,
        original_title: json['original_title'] as String,
        overview: json['overview'] as String,
        popularity: json['popularity'] as dynamic,
        poster_path: json['poster_path'] == null
            ? "https://imge.androidappsapk.co/P7Q4mCh2eIftapjVFx7ePrMev9VwLxzmqeoo8_kJ-Bb6Pgv3oh_tIbG-ZvPTFAayFA=s300"
            : baseUrl + posterPath,
        release_date: json['release_date'] as String,
        title: json['title'] as String,
        video: json['video'] as bool,
        vote_count: json['vote_count'] as int,
        voteAverage: rate,
        genre_ids: upcomingGenreIds);
  }

  @override
  String toString() {
    String data = "<Returns>${this.poster_path}";
    return data;
  }
}

class MovieGenreIds {
  final int id;

  MovieGenreIds({this.id});

  factory MovieGenreIds.fromJson(json) {
    return MovieGenreIds(id: json);
  }
}

class MoviesDates {
  final String maximum;
  final String minimum;

  MoviesDates({this.maximum, this.minimum});

  factory MoviesDates.fromJson(Map<String, dynamic> json) {
    return MoviesDates(
        maximum: json['maximum'] as String, minimum: json['minimum'] as String);
  }
}

class Movies {
  final int page;
  final int total_pages;
  final int total_results;
  final MoviesDates dates;
  final List<MovieResult> results;

  Movies(
      {this.page,
      this.total_pages,
      this.total_results,
      this.dates,
      this.results});

  factory Movies.fromJson(Map<String, dynamic> parsedJson) {
    var _dates = parsedJson['dates'];
    List _results = parsedJson['results'] as List;

    MoviesDates upcomingDates =
        _dates != null ? MoviesDates.fromJson(_dates) : _dates;
    List<MovieResult> upcomingResults = _results != null
        ? _results.map((i) => MovieResult.fromJson(i)).toList()
        : _results;

    return Movies(
        page: parsedJson['page'],
        total_pages: parsedJson['total_pages'],
        total_results: parsedJson['total_results'],
        dates: upcomingDates,
        results: upcomingResults);
  }
  @override
  String toString() {
    String data = "<Movies>: ${this.results.length}";
    return data;
  }
}
