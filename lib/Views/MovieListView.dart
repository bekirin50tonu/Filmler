import 'package:Filmler/Controllers/GentresController.dart';
import 'package:Filmler/Models/Genres.dart';
import 'package:Filmler/Models/Movies.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'MovieDetailView.dart';

// ignore: must_be_immutable
class MovieDataViewer extends StatelessWidget {
  final Movies data;
  final int index;
  MovieDataViewer({Key key, @required this.data, @required this.index})
      : super(key: key);
  var getGenresController = GenresController();
  @override
  Widget build(BuildContext context) {
    Genres genres = getGenresController.getValue();
    return InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DataRoute(
                    data: data.results[index],
                    controller: getGenresController,
                    genres: genres))),
        child: Column(children: [
          Card(
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.black87
                      : Colors.grey.shade300,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: CachedNetworkImage(
                          imageUrl: data.results[index].poster_path,
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                      Container(
                        child: Center(
                          child: ListTile(
                              title: Text(data.results[index].title,
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.dark
                                          ? Colors.grey
                                          : Colors.black)),
                              subtitle: Text(
                                '${data.results[index].release_date != "" ? DateFormat("dd/MM/yyyy").format(DateTime.parse(data.results[index].release_date)) : data.results[index].release_date}',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                        ? Colors.grey
                                        : Colors.black),
                              )),
                        ),
                      ),
                    ]),
              ))
        ]));
  }
}
