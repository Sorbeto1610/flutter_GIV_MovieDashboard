import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'movie.dart';
import 'fetchService.dart';
import 'comparePopularity.dart'; // Importer la fonction comparePopularityList

class graphPage extends StatefulWidget {
  @override
  _graphPageState createState() => _graphPageState();
}

class _graphPageState extends State<graphPage> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = FetchService.fetchMoviesTrend();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Popularity Chart'),
      ),
      body: Center(
        child: FutureBuilder<List<Movie>>(
          future: _moviesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Container(
                height: 400,
                padding: EdgeInsets.all(20.0),
                child: _buildBarChart(snapshot.data!),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildBarChart(List<Movie> movies) {
    // Tri de la liste de films par popularité (du moins populaire au plus populaire)
    movies.sort((a, b) => a.popularity.compareTo(b.popularity));

    // Appel de comparePopularityList avec la liste triée de films
    final List<charts.Series<Movie, String>> seriesList =
    comparePopularityList(movies);

    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: true,
    );
  }
}

