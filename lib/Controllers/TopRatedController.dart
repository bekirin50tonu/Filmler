import 'dart:convert';

import 'package:Filmler/Models/Movies.dart';
import 'package:http/http.dart' as http;

//Response Data Class
class TopRatedController {
  //Variables
  String apikey = "078e3b11caddc0a99f5c1c4978749008";
  String page = "1";
  Movies data;

  //Methods
  Movies parseUser(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return Movies.fromJson(parsed);
  }

  // ignore: missing_return
  Future<Movies> fetchDatas(String page) async {
    print("Page:" + page);
    this.page = page;
    String url =
        "https://api.themoviedb.org/3/movie/top_rated?api_key=${this.apikey}&language=tr-TR&page=${this.page}&region=tr";
    final response = await http.get(
      Uri.parse(url),
    );
    this.data = parseUser(response.body);
    return this.data;
  }
}
