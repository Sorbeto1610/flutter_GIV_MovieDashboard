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
      body: Center(
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
    return DropdownButton<Genre>(
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
      style: TextStyle(fontSize: 16.0), // Style pour le texte du bouton déroulant
      dropdownColor: Colors.red[400], // Couleur du menu déroulant
      elevation: 5, // Élévation du menu déroulant
      icon: Icon(Icons.arrow_drop_down), // Icône du bouton déroulant
      isExpanded: true, // Définir la largeur du bouton déroulant sur la largeur de son parent
      underline: Container(), // Retirer la ligne en dessous du bouton déroulant
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
          Image.asset('assets/loading.gif'), // Remplacer 'assets/loading.gif' par le chemin de votre GIF
          SizedBox(height: 20),
          Text('Aucun film à afficher'),
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
    );
  }
}
