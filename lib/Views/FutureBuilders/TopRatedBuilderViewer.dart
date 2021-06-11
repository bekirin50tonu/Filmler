import 'dart:async';

import 'package:Filmler/Controllers/TopRatedController.dart';
import 'package:Filmler/Models/Movies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../MovieListView.dart';

class TopRatedFutureBuilderView extends StatefulWidget {
  TopRatedFutureBuilderView({Key key}) : super(key: key);

  @override
  _TopRatedFutureBuilderViewState createState() =>
      _TopRatedFutureBuilderViewState();
}

class _TopRatedFutureBuilderViewState extends State<TopRatedFutureBuilderView> {
  final String baseUrl = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2";
  int currentPage = 1;
  StreamController<List<Movies>> _streamController =
      StreamController<List<Movies>>();
  TopRatedController topratedController;
  ScrollController _scrollController = ScrollController();
  List<Movies> _items = <Movies>[];
  int _count = 0;

  var _maxResults = 0;

  int _maxPage = 1;

  @override
  void dispose() {
    print("Dispose olmak");
    _streamController.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    this.topratedController = TopRatedController();
    _fetchMovies(currentPage.toString());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          currentPage < _maxPage) {
        currentPage = currentPage < _maxPage ? currentPage + 1 : _maxPage;
        print("SEARCHVALUE: " +
            currentPage.toString() +
            "\nMaxPage: " +
            _maxPage.toString());
        _fetchMovies(currentPage.toString());
      }
    });
    super.initState();
  }

  Future<void> _fetchMovies(String search) async {
    String value = search;
    print("SEARCHVALUE: " + search);
    var items = await topratedController.fetchDatas(value);
    _maxResults = items.total_results;
    _maxPage = items.total_pages;
    _count = _count < _maxResults ? _count + items.results.length : _maxResults;
    print(_count);
    if (items == null) return;
    _items.add(items);
    _streamController.add(_items);

    return;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshBuilder,
      child: StreamBuilder(
        stream: _streamController.stream,
        builder: (context, AsyncSnapshot<List<Movies>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return noConnection(context);
            case ConnectionState.waiting:
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Yükleniyor..."),
                ],
              ));
            case ConnectionState.active:
            case ConnectionState.done:
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      itemCount: _count,
                      itemBuilder: (context, index) {
                        int dataIndex = index ~/ 20;
                        int resultIndex = index % 20;
                        print("DataIndex: " +
                            dataIndex.toString() +
                            "\nIndex: " +
                            index.toString());
                        return MovieDataViewer(
                            data: snapshot.data[dataIndex], index: resultIndex);
                      },
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }

  Widget noConnection(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        child: Text("Bağlantı Sağlanamadı!"));
  }

  Future<void> _refreshBuilder() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {});
    _fetchMovies(this.currentPage.toString());
    print("yenilendi: " + this.currentPage.toString());
    return null;
  }
}
