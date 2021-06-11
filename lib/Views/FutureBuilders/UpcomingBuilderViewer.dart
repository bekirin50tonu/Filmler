import 'dart:async';

import 'package:Filmler/Controllers/UpcomingController.dart';
import 'package:Filmler/Models/Movies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../MovieListView.dart';

class UpcomingFutureBuilderView extends StatefulWidget {
  UpcomingFutureBuilderView({Key key}) : super(key: key);

  @override
  State<UpcomingFutureBuilderView> createState() =>
      _UpcomingFutureBuilderViewState();
}

class _UpcomingFutureBuilderViewState extends State<UpcomingFutureBuilderView> {
  final String baseUrl = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2";
  StreamController<List<Movies>> _streamController =
      StreamController<List<Movies>>();
  UpcomingController upcomingController;
  ScrollController _scrollController = ScrollController();
  List<Movies> _items = <Movies>[];
  int _count = 0;
  int currentPage = 1;

  var _maxResults = 0;

  int _maxPage = 0;

  @override
  void dispose() {
    print("Dispose olmak");
    _streamController.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    this.upcomingController = UpcomingController();
    _fetchMovies(this.currentPage.toString());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          currentPage < _maxPage) {
        currentPage = currentPage < _maxPage ? currentPage + 1 : _maxPage;
        _fetchMovies(this.currentPage.toString());
      }
    });
    super.initState();
  }

  Future<void> _fetchMovies(String search) async {
    String value = search;

    var items = await upcomingController.fetchDatas(value);
    _maxResults = items.total_results;
    _maxPage = items.total_pages;
    _count = _count < _maxResults ? _count + items.results.length : _maxResults;
    print("ItemCount: " +
        _count.toString() +
        "\nTotalResults: " +
        _maxResults.toString());
    if (items == null) return;
    _items.add(items);
    _streamController.add(_items);

    return;
  }

  Future<void> _refreshBuilder() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {});
    currentPage = 0;
    _fetchMovies(currentPage.toString());
    _items.clear();
    return null;
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
}
