import 'package:flutter/material.dart';
import 'movie.dart';
import 'fetchService.dart';
import 'countingGenres.dart';
import 'genre.dart';
import 'package:fl_chart/fl_chart.dart'; // Importez uniquement le PieChart de fl_chart

class PiechartPage extends StatefulWidget {
  @override
  _PiechartPageState createState() => _PiechartPageState();
}

class _PiechartPageState extends State<PiechartPage> {
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Quantity of movies per genre',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0, // Remove elevation
          backgroundColor: Colors.transparent,
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

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20.0), // Rounded corners
                    ),
                    child: SizedBox(
                      height: 3000,
                      width: 3000,
                      child: Stack(
                        children: [
                          PieChart(
                            PieChartData(
                              sections: genrePercentages.entries.map((entry) {
                                return PieChartSectionData(
                                  color: Colors.primaries.elementAt(
                                    genrePercentages.keys
                                        .toList()
                                        .indexOf(entry.key),
                                  ),
                                  value: entry.value,
                                  title: '',
                                  titlePositionPercentageOffset: 0.8,
                                  radius: 100,
                                  titleStyle: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                              borderData: FlBorderData(
                                show: true, // Afficher les bordures
                                border: Border.all(
                                  color: Colors.white, // Couleur des bordures
                                  width: 7, // Largeur des bordures
                                ),
                              ),
                              sectionsSpace: 7,
                              centerSpaceRadius: 110,
                              startDegreeOffset: -90,
                            ),
                          ),
                          Positioned(
                            bottom: 20, // ajustez la position verticale selon vos préférences
                            left: 0,
                            right: 0,
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: genrePercentages.entries.map((entry) {
                                final title = ' ${entry.key} (${entry.value.toStringAsFixed(1)}%)  ';
                                final color = Colors.primaries.elementAt(
                                  genrePercentages.keys.toList().indexOf(entry.key),
                                );

                                return Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        color: color,
                                      ),
                                      SizedBox(width: 5),
                                      Text(title, style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}