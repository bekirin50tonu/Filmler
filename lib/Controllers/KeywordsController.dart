import 'dart:convert';

import 'package:Filmler/Models/Keywords.dart';
import 'package:http/http.dart' as http;

//Response Data Class
class KeywordsController {
  //Variables
  static String apikey = "078e3b11caddc0a99f5c1c4978749008";
  String page = "1";
  Keywords keywords;

  //Methods

  static List<Results> parseKeywords(String responseBody) {
    final parsed = jsonDecode(responseBody);
    var data = Keywords.fromJson(parsed).results.toList();
    return data;
  }

  static Future<List<Results>> fetchKeywords(String searchValue) async {
    String search = searchValue;
    print("Search Value Key: " + search);
    String url =
        "https://api.themoviedb.org/3/search/keyword?api_key=$apikey&query=$search&page=1";
    final response = await http.get(
      Uri.parse(url),
    );
    print(response.body);
    var data = parseKeywords(response.body);
    return data;
  }
}
