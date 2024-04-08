import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'movie.dart';
import 'fetchService.dart';
import 'countingGenres.dart';
import 'genre.dart';

class PiechartPage extends StatefulWidget {
  final Function(Map<String, double>) onGenreSelected1;

  const PiechartPage({Key? key, required this.onGenreSelected1}) : super(key: key);

  @override
  _PiechartPageState createState() => _PiechartPageState();
}

class _PiechartPageState extends State<PiechartPage> {
  late Future<List<Movie>> _moviesFuture;
  late Future<List<Genre>> _genresFuture;
  Map<String, double> _lastGenrePercentages = {};

  @override
  void initState() {
    super.initState();
    _moviesFuture = FetchService.fetchMoviesTrend();
    _genresFuture = FetchService.fetchMoviesListGenre();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_moviesFuture, _genresFuture]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else {
          final List<Movie> movies = snapshot.data![0];
          final List<Genre> genres = snapshot.data![1];
          final Map<String, int> genreCounts = countingGenreDictionary(movies, genres);
          final Map<String, double> genrePercentages = calculateGenrePercentages(genreCounts);

          bool hasDataChanged = _lastGenrePercentages.toString() != genrePercentages.toString();
          if (hasDataChanged) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onGenreSelected1(genrePercentages);
            });
            _lastGenrePercentages = Map.from(genrePercentages);
          }

          final List<PieChartSectionData> sections = genrePercentages.entries.map((entry) {
            final colorIndex = genres.indexWhere((genre) => genre.name == entry.key) % Colors.primaries.length;
            return PieChartSectionData(
              color: Colors.primaries[colorIndex],
              value: entry.value,
              title: entry.key, // Modification ici pour afficher seulement le nom du genre
              titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              radius: 100,
            );
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: PieChart(
                PieChartData(
                  sections: sections,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 80,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
