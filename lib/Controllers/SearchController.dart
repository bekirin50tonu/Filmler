import 'dart:convert';

import 'package:Filmler/Models/Keywords.dart';
import 'package:Filmler/Models/Movies.dart';

import 'package:http/http.dart' as http;

//Response Data Class
class SearchController {
  //Variables
  String apikey = "078e3b11caddc0a99f5c1c4978749008";
  int _page = 1;
  Movies data;
  Keywords keywords;
  //Methods
  Movies parseMovies(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return Movies.fromJson(parsed);
  }

  // ignore: missing_return
  Future<Movies> fetchMovies(String searchValue, int pageValue) async {
    String search = searchValue.trim().replaceAll(" ", "%20");
    _page = pageValue;
    print("SearchKey: " + search + "\nPageCount:" + _page.toString());
    String url =
        "https://api.themoviedb.org/3/search/movie?api_key=${this.apikey}&language=tr-TR&query=$search&page=${_page.toString()}";
    final response = await http.get(
      Uri.parse(url),
    );
    print(response.body);
    this.data = parseMovies(response.body);
    return this.data;
  }
}
