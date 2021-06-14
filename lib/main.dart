import 'package:Filmler/Views/FutureBuilders/PlayingBuilderViewer.dart';
import 'package:Filmler/Views/FutureBuilders/TopRatedBuilderViewer.dart';
import 'package:Filmler/Views/FutureBuilders/UpcomingBuilderViewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Controllers/GentresController.dart';
import 'Controllers/UpcomingController.dart';
import 'Models/Genres.dart';
import 'Models/Movies.dart';
import 'Views/FutureBuilders/PopularBuilderViewer.dart';
import 'Views/FutureBuilders/SearchBuilder.dart';

void main() {
  runApp(MyApp());
}

//Class

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Filmler',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Filmler'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //VARIABLES
  Genres genres;
  Movies movies;
  int _currentIndex = 0;

  @override
  initState() {
    genres = GenresController().getValue();
    movies = UpcomingController().getValue();
    super.initState();
  }

  final tabs = [
    Container(child: UpcomingFutureBuilderView()),
    Container(child: PopularFutureBuilderView()),
    Container(child: SearchBuilder()),
    Container(child: PlayingFutureBuilderView()),
    Container(child: TopRatedFutureBuilderView())
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Yakında'),
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.people_outline_sharp),
                title: Text('Popülar'),
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text('Arama'),
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.album),
                title: Text('Yayında'),
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.topic),
                title: Text('En Çok Oy Alanlar'),
                backgroundColor: Colors.blue)
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ));
  }
}
