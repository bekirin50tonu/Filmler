import 'dart:convert';

import 'package:Filmler/Models/Genres.dart';

import '../Models/Movies.dart';
import 'package:http/http.dart' as http;

//Response Data Class
class GenresController {
  //Variables
  String apikey = "078e3b11caddc0a99f5c1c4978749008";
  String page = "1";
  Genres genres;
  List<Genre> genreList = [];

  // ignore: missing_return
  List<Genre> getGenrefromGenreIds(List<MovieGenreIds> genreIDs) {
    genreList.clear();
    print("genrefromadasd girmiş olmak: " +
        genres.genres.length.toString() +
        "\nDiğer Data Gelmek: " +
        genreIDs.length.toString());
    for (int i = 0; i < genres.genres.length; i++) {
      for (int j = 0; j < genreIDs.length; j++) {
        if (genreIDs[j].id == genres.genres[i].id) {
          genreList.add(genres.genres[i]);
        }
      }
    }
    print("Genreids Almış ve Vermiş Olmak: " + genreList.length.toString());
    return genreList;
  }

  Genres getValue() {
    print("getValue Girmek, Olmak");
    Future<Genres> future = this.fetchDatas(http.Client());
    future
        .then((value) => handleValue(value))
        .catchError((error) => handleError(error));
    return this.genres;
  }

  handleValue(Genres value) {
    print("GetValueimiş::" + value.genres.length.toString());
    this.genres = value;
    return value;
  }

  handleError(error) {
    print(error);
    return error;
  }

  //Methods
  Genres parseGenres(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return Genres.fromJson(parsed);
  }

  Future<Genres> fetchDatas(http.Client client) async {
    String url =
        "https://api.themoviedb.org/3/genre/movie/list?api_key=${this.apikey}&language=tr-TR";
    final response = await http.get(
      Uri.parse(url),
    );
    return parseGenres(response.body);
  }
}
