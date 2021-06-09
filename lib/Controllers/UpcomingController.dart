import 'dart:convert';

import 'package:Filmler/Models/Movies.dart';
import 'package:http/http.dart' as http;

//Response Data Class
class UpcomingController {
  //Variables
  String apikey = "078e3b11caddc0a99f5c1c4978749008";
  String page = "1";
  Movies data;

  Movies getValue() {
    print("getValue Girmek, Olmak");
    Future<Movies> future = this.fetchDatas("1");
    future
        .then((value) => handleValue(value))
        .catchError((error) => handleError(error));
    return data;
  }

  handleValue(Movies value) {
    print(value);
    this.data = value;
    return value;
  }

  handleError(error) {
    print(error);
  }

  //Methods
  Movies parseUser(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return Movies.fromJson(parsed);
  }

  // ignore: missing_return
  Future<Movies> fetchDatas(String page) async {
    if (data != null) return this.data;
    print(data);
    this.page = page;
    String url =
        "https://api.themoviedb.org/3/movie/upcoming?api_key=${this.apikey}&language=tr-TR&page=${this.page}&region=TR";
    final response = await http.get(
      Uri.parse(url),
    );
    this.data = parseUser(response.body);
    return this.data;
  }
}
