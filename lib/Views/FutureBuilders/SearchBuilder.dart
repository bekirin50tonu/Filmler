import 'dart:async';

import 'package:Filmler/Controllers/KeywordsController.dart';
import 'package:Filmler/Controllers/SearchController.dart';
import 'package:Filmler/Models/Keywords.dart';
import 'package:Filmler/Models/Movies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../MovieListView.dart';

class SearchBuilder extends StatefulWidget {
  @override
  _SearchBuilder createState() => new _SearchBuilder();
}

class _SearchBuilder extends State<SearchBuilder> {
  final TextEditingController controller = TextEditingController();
  StreamController<List<Movies>> _streamController = StreamController();
  StreamController<Keywords> _streamControllerKeywords = StreamController();
  SearchController searchController;
  KeywordsController keywordsController;
  String searchText = "mortal";
  List<Movies> _items = <Movies>[];
  ScrollController _scrollController = ScrollController();
  int _count = 0;
  int currentPage = 1;
  Movies movies;
  Keywords keywords;

  var _maxResults = 0;

  int _maxPage = 0;

  //Future<Movies> data;

  @override
  void dispose() {
    print("Dispose olmak");
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    print("State girmek");
    this.searchController = SearchController();
    this.keywordsController = KeywordsController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          currentPage < _maxPage) {
        currentPage = currentPage < _maxPage ? currentPage + 1 : _maxPage;
        _fetchMovies(this.searchText, currentPage);
      }
    });
    super.initState();
  }

  Future<void> _fetchMovies(String search, int page) async {
    String value = search;
    var items = await searchController.fetchMovies(value, page);
    _maxResults = items.total_results;
    _maxPage = items.total_pages;
    _count = _count < _maxResults ? _count + items.results.length : _maxResults;
    print("İtem:" + items.results.length.toString());
    print("İtem:" + items.results[0].toString());
    if (items == null) return;
    _items.add(items);
    _streamController.add(_items);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: TypeAheadField<Results>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              autofocus: false,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => controller.clear()),
                icon: Icon(Icons.search),
                hintText: 'Film Giriniz.',
                hintStyle: TextStyle(
                    fontFamily: 'Metropolis-SemiBold',
                    color: Color.fromRGBO(197, 197, 197, 1)),
              ),
            ),
            suggestionsCallback: (String pattern) async {
              _fetchMovies(pattern, 1);
              _items.clear();
              var data = await KeywordsController.fetchKeywords(pattern);
              return data;
            },
            onSuggestionSelected: (Results suggestion) {
              controller.text = suggestion.name;
              _items.clear();
              _fetchMovies(suggestion.name, 1);
            },
            noItemsFoundBuilder: (context) =>
                Center(child: Text("Film Bulunamadı")),
            itemBuilder: (BuildContext context, Results itemData) {
              return Container(child: ListTile(title: Text(itemData.name)));
            },
          ),
        ),
        Expanded(
          child: Container(
              padding: const EdgeInsets.all(4.0),
              child: StreamBuilder(
                stream: _streamController.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Movies>> snapshot) {
                  if (!snapshot.hasData)
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.search), Text("Arama")]);

                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return noConnection(context);
                    case ConnectionState.waiting:
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text("Yükleniyor..."),
                        ],
                      ));
                    case (ConnectionState.done):
                    case ConnectionState.active:
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
                                    data: snapshot.data[dataIndex],
                                    index: resultIndex);
                              },
                            ),
                          ),
                        ],
                      );
                  }
                },
              )),
        ),
      ],
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
    currentPage = 1;
    _fetchMovies(this.currentPage.toString(), currentPage);
    print("yenilendi: " + this.currentPage.toString());
    return null;
  }
}
