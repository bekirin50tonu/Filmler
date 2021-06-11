import 'package:Filmler/Controllers/GentresController.dart';
import 'package:Filmler/Models/Genres.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/Movies.dart';

class DataRoute extends StatefulWidget {
  final MovieResult data;
  final GenresController controller;
  final Genres genres;

  DataRoute({Key key, @required this.data, this.controller, this.genres})
      : super(key: key);

  @override
  State<DataRoute> createState() => _DataRouteState();
}

class _DataRouteState extends State<DataRoute> {
  final String baseUrl = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2";
  List<Genre> genre;

  @override
  initState() {
    genre = widget.controller.getGenrefromGenreIds(widget.data.genre_ids);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.data.title),
      ),
      backgroundColor: Colors.black54,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.data.backdrop_path == null
                ? null
                : baseUrl + widget.data.backdrop_path),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.black54),
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Card(
                    child: Container(
                        child: CachedNetworkImage(
                  imageUrl: widget.data.poster_path,
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ))),
                Container(
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(197, 197, 197, 0.5)),
                  child: Column(children: [
                    Text(widget.data.original_title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 2,
                            fontSize: 20)),
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListTile(
                            title: Text("Konusu:"),
                            subtitle: Text(widget.data.overview)),
                        ListTile(
                            title: Text("Orijinal Dili"),
                            subtitle: Text(widget.data.original_language)),
                        ListTile(
                            title: Text("Çıkış Tarihi"),
                            subtitle: Text(
                                '${widget.data.release_date != "" ? DateFormat("dd/MM/yyyy").format(DateTime.parse(widget.data.release_date)) : widget.data.release_date}')),
                        ListTile(
                            title: Text("Oy Ortalaması",
                                textAlign: TextAlign.center),
                            subtitle: Column(children: [
                              _rateStar(widget.data.voteAverage),
                              Text(
                                  "${widget.data.voteAverage}/${widget.data.vote_count}")
                            ]))
                      ],
                    )),
                    Container(
                        child: Column(
                      children: [
                        Text("Türleri",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 2,
                                fontSize: 20)),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: genre.length,
                            // ignore: missing_return
                            itemBuilder: (context, index) {
                              return ListTile(title: Text(genre[index].name));
                            }),
                      ],
                    ))
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rateStar(double voteAverage) {
    int _maxSize = 5;
    int _voteCount = voteAverage.round();
    final stars = List<Widget>.generate(
        _maxSize,
        (index) => index < _voteCount / 2
            ? Icon(
                Icons.star,
                color: Colors.green,
              )
            : Icon(Icons.star_border_outlined, color: Colors.yellow));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: stars);
  }
}
