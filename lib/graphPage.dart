import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'movie.dart';
import 'genre.dart';
import 'fetchService.dart';
import 'comparePopularity.dart'; // Importer la fonction comparePopularityList

class graphPage extends StatefulWidget {
  @override
  _graphPageState createState() => _graphPageState();
}

class _graphPageState extends State<graphPage> {
  late Future<List<Movie>> _moviesFuture;
  late Future<List<Genre>> _genresFuture;
  late List<Genre> _genresList;
  Genre? _selectedGenre; // Genre sélectionné

  @override
  void initState() {
    super.initState();
    _moviesFuture = FetchService.fetchMoviesTrend();
    _genresFuture = FetchService.fetchMoviesListGenre();
    _selectedGenre = null; // Initialiser le genre sélectionné à null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Popularity Chart'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF91180B),
              Color(0xFFB9220F),
              Color(0xFFE32D13),
              Color(0xFFF85138),
              Color(0xFFFF6666),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FutureBuilder<List<Genre>>(
            future: _genresFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                _genresList = snapshot.data!;
                return _buildBody();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildGenreDropdown(),
        SizedBox(height: 20),
        Expanded(
          child: FutureBuilder<List<Movie>>(
            future: _moviesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return _buildGraph(snapshot.data!);
              }
            },
          ),
        ),
      ],
    );
  }
  Widget _buildGenreDropdown() {
    return DropdownButtonFormField<Genre>(
      value: _selectedGenre,
      onChanged: (Genre? newValue) {
        setState(() {
          _selectedGenre = newValue;
        });
      },
      items: [
        DropdownMenuItem<Genre>(
          value: null,
          child: Text('All'),
        ),
        ..._genresList.map<DropdownMenuItem<Genre>>((Genre genre) {
          return DropdownMenuItem<Genre>(
            value: genre,
            child: Text(genre.name),
          );
        }).toList(),
      ],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: 'Select a genre', // Texte d'invite pour indiquer qu'on peut cliquer
      ),
    );
  }


  Widget _buildGraph(List<Movie> movies) {
    // Filtrer les films par genre sélectionné
    final List<Movie> filteredMovies = _selectedGenre != null
        ? movies.where((movie) => movie.genreIds.contains(_selectedGenre!.id)).toList()
        : List.from(movies); // Copie la liste complète de films si aucun genre n'est sélectionné

    // Si la liste de films filtrée est vide, afficher un message avec un GIF
    if (filteredMovies.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Adjust width and height of the Image.asset widget to make it smaller
          Image.asset(
            'assets/clap.gif',
            width: 100, // Adjust width as needed
            height: 100, // Adjust height as needed
          ),
          SizedBox(height: 20),
          // Set the style of the Text widget to make the text white
          Text(
            'Movie in the making...',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      );
    }
    // Tri de la liste de films filtrée par popularité (du moins populaire au plus populaire)
    filteredMovies.sort((a, b) => a.popularity.compareTo(b.popularity));

    // Appel de comparePopularityList avec la liste de films triée par popularité
    final List<charts.Series<Movie, String>> seriesList =
    comparePopularityList(filteredMovies.reversed.toList()); // Inverser la liste pour afficher du moins populaire au plus populaire

    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: true,
      behaviors: [
        // Add an axis spec to specify a custom measure axis label.
        charts.ChartTitle('Movies', behaviorPosition: charts.BehaviorPosition.bottom, titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
        charts.ChartTitle('Popularity', behaviorPosition: charts.BehaviorPosition.start, titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
        // Rotate the titles on domain axis.

      ],
    );
  }
}
