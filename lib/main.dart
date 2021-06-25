import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  //app bar icon when search bar is hidden
  IconData _searchIcon = Icons.search;
  // initial state of search bar is hidden
  bool _isSearchBarHidden = true;
  //
  Widget _appBarWidget = Text("SpaceX missions");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarWidget,
        centerTitle: true,
        actions: [
          //TODO implement on pressed
          IconButton(onPressed: _onSearchButtonPressed, icon: Icon(_searchIcon))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //TODO da spostare nel modello
  void _onSearchButtonPressed() {
    setState(() {
      _isSearchBarHidden = !_isSearchBarHidden;
      if (_isSearchBarHidden)
        _appBarWidget = Text("SpaceX missions");
      else {
        _appBarWidget = TextField();
      }
    });
  }
}
