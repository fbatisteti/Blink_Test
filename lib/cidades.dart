// Imports
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/*
  Cidades

    - Previously "RandomWords", from Flutter website tutorial
*/
class Cidades extends StatefulWidget {
  @override
  _CidadesState createState() => _CidadesState();
}

/*
  _CidadesState

    - Previsouly "_RandomWordsState", from Flutter website tutorial
    - Fetches city list from 'assets/cidades.txt' instead of package
    - Show the city list and allows favoritation
    - Favorite cities can be checked on another screen
*/
class _CidadesState extends State<Cidades> {
  // Styling
  final _biggerFont = TextStyle(fontSize: 18.0);

  // This variable will hold the list of favorite cities
  final _saved = Set<String>();

  // This variable will hold the list of cities
  List<String> _cidades = [];

  /*
    Method: _loadCidades()

      - Paramenters: none
      - Returns: list of cities from "assets/cidades.txt"
  */
  Future<List<String>> _loadCidades() async {
    List<String> cidades = [];
    await rootBundle.loadString('assets/cidades.txt').then((x) {
      for (String cidade in LineSplitter().convert(x)) {
        cidades.add(cidade);
      }
    });
    return cidades;
  }

  // The following blocks loads the .txt file and associate with the variable
  @override
  void initState() {
    _setup();
    super.initState();
  }

  _setup() async {
    List<String> cidades = await _loadCidades();
    setState(() {
      _cidades = cidades;
    });
  }

  /*
    Widget: _cidadesListar()

      - Shows all the cities from variable "cidades"
      - Separates each city with a divider

      Notes:
        Considering there will be a divider between each two cities, the
        index will go to two times the list total lenght (meaning one
        divider below each city)... the code as is will clip the last divider 
  */
  Widget _cidadesListar() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd && i != (_cidades.length * 2 - 1)) return Divider();

        final index = i ~/ 2;

        if (i == (_cidades.length) * 2 - 1) {
          return null; // break
        } else {
          return _buildRow(_cidades[index]); // print
        }
      },
    );
  }

  /*
    Widget: _buildRow()

      - Each row has the city name and a "favorite" button
  */
  Widget _buildRow(String cidade) {
    // Checks if is favorited
    final alreadySaved = _saved.contains(cidade);

    return ListTile(
      title: Text(
        cidade,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Color.fromRGBO(196, 0, 8, 1.0) : null,
      ),
      onTap: () {
        setState(() {
          alreadySaved ? _saved.remove(cidade) : _saved.add(cidade);
        });
      },
    );
  }

  /*
    Routing: _pushSaved()

      - Will open a new widget on top of screen to show the favorited listing
  */
  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        final tiles = _saved.map(
          (String cidade) {
            return ListTile(
              title: Text(
                cidade,
                style: _biggerFont,
              ),
            );
          },
        );

        final divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Municípios Favoritos'),
          ),
          body: ListView(children: divided),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset('assets/bandeira.png', fit: BoxFit.scaleDown),
        ),
        title: Text('Municípios de SP'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _cidadesListar(),
    );
  }
}
