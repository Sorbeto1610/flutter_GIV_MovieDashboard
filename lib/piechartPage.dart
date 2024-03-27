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
          centerTitle: true,
          elevation: 0, // Remove elevation
          backgroundColor: Colors.transparent,
        ),
        body: FutureBuilder(
          future: Future.wait([_moviesFuture, _genresFuture]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Image.asset('assets/clap.gif'));
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else {
              final List<Movie> movies = snapshot.data![0] as List<Movie>;
              final List<Genre> genres = snapshot.data![1] as List<Genre>;

              final Map<String, int> genreCounts =
              countingGenreDictionary(movies, genres);
              final Map<String, double> genrePercentages =
              calculateGenrePercentages(genreCounts);

              // Trier les sections du pie chart par ordre alphabétique des genres
              final sortedGenreCounts = genreCounts.entries.toList()
                ..sort((a, b) => a.key.compareTo(b.key));

              // Créer une liste de couleurs primaires triées par ordre alphabétique des genres
              final sortedPrimaryColors = sortedGenreCounts.map((entry) {
                final genreIndex = genres.indexWhere((genre) => genre.name == entry.key);
                final colorIndex = genreIndex % Colors.primaries.length;
                return Colors.primaries[colorIndex];
              }).toList();

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(
                    constraints: BoxConstraints.expand(), // Ensure the container fills the available space
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20.0), // Rounded corners
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: PieChart(
                                    PieChartData(
                                      sections: sortedGenreCounts.map((entry) {
                                        return PieChartSectionData(
                                          color: sortedPrimaryColors[sortedGenreCounts.indexOf(entry)],
                                          value: entry.value.toDouble(),
                                          title: '${entry.value}',
                                          titlePositionPercentageOffset: 1.4,
                                          radius: constraints.maxWidth > constraints.maxHeight
                                              ? constraints.maxHeight / 8.5 // Adjust based on maxHeight for landscape mode
                                              : constraints.maxWidth / 8.5, // Adjust based on maxWidth for portrait mode
                                          titleStyle: TextStyle(
                                            fontSize: constraints.maxWidth > constraints.maxHeight
                                                ? constraints.maxHeight * 0.04 // Adjust font size based on maxHeight for landscape mode
                                                : constraints.maxWidth * 0.04, // Adjust font size based on maxWidth for portrait mode
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
                                      centerSpaceRadius: constraints.maxWidth > constraints.maxHeight
                                          ? constraints.maxHeight / 5 // Adjust based on maxHeight for landscape mode
                                          : constraints.maxWidth / 5, // Adjust based on maxWidth for portrait mode
                                      startDegreeOffset: -90,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: sortedGenreCounts.map((entry) {
                                final title =
                                    ' ${entry.key} (${genrePercentages[entry.key]!.toStringAsFixed(1)}%)  ';
                                final color = sortedPrimaryColors[sortedGenreCounts.indexOf(entry)];

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
                                      Text(title,
                                          style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
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
