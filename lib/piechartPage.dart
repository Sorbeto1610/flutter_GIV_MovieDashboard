import 'package:flutter/material.dart';
import 'movie_carousel_view.dart';
import 'movie.dart';
import 'movie_list.dart';
import 'fetchService.dart';
import 'countingGenres.dart';
import 'genre.dart';
import 'package:fl_chart/fl_chart.dart'; // Importez uniquement le PieChart de fl_chart

class piechartPage extends StatefulWidget {
  @override
  piechartPageState createState() => piechartPageState();
}

class piechartPageState extends State<piechartPage> {
  late Future<List<Movie>> _moviesFuture;
  late Future<List<Genre>> _genresFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = FetchService.fetchMoviesTrend();
    _genresFuture = FetchService.fetchMoviesListGenre();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(

          title: Text('Exemple de diagramme circulaire'),
        ),
        body: FutureBuilder(
          future: Future.wait([_moviesFuture, _genresFuture]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else {
              final List<Movie> movies = snapshot.data![0] as List<Movie>;
              final List<Genre> genres = snapshot.data![1] as List<Genre>;

              final Map<String, int> genreCounts =
              countingGenreDictionary(movies, genres);
              final Map<String, double> genrePercentages =
              calculateGenrePercentages(genreCounts);

              return PieChart(
                PieChartData(
                  sections: genrePercentages.entries.map((entry) {
                    return PieChartSectionData(
                      color: Colors.primaries.elementAt(genrePercentages.keys.toList().indexOf(entry.key)),
                      value: entry.value,
                      title: '${entry.key} (${entry.value.toStringAsFixed(1)}%)',
                      radius: 150,
                      titleStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
                swapAnimationDuration: Duration(milliseconds: 800),

              );
            }
          },
        ),
      ),
    );
  }
}
