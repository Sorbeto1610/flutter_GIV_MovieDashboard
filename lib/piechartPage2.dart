import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'movie.dart';
import 'fetchService.dart';
import 'genre.dart';

class PiechartPage2 extends StatefulWidget {
  final Function(Map<String, double>) onGenreSelected;

  const PiechartPage2({Key? key, required this.onGenreSelected}) : super(key: key);

  @override
  _PiechartPage2State createState() => _PiechartPage2State();
}

class _PiechartPage2State extends State<PiechartPage2> {
  late Future<List<Movie>> _moviesFuture;
  late Future<List<Genre>> _genresFuture;
  late Map<String, double> _genrePopularityMap = {};

  @override
  void initState() {
    super.initState();
    _moviesFuture = FetchService.fetchMoviesTrend();
    _genresFuture = FetchService.fetchMoviesListGenre();
    _loadData();
  }

  Future<void> _loadData() async {
    final List<Movie> movies = await _moviesFuture;
    final List<Genre> genres = await _genresFuture;
    double totalPopularity = movies.fold(0, (acc, movie) => acc + movie.popularity);
    Map<String, double> genrePopularityMap = {};
    for (var genre in genres) {
      double genrePopularity = 0;
      for (var movie in movies) {
        if (movie.genreIds.contains(genre.id)) {
          genrePopularity += movie.popularity;
        }
      }
      double genrePercentage = (genrePopularity / totalPopularity) * 100;
      if (genrePercentage > 0) {
        genrePopularityMap[genre.name] = genrePercentage;
      }
    }

    // Normalize percentages if total exceeds 100%
    double sumPercentages = genrePopularityMap.values.fold(0, (acc, percentage) => acc + percentage);
    if (sumPercentages > 100) {
      genrePopularityMap.forEach((key, value) {
        genrePopularityMap[key] = (value / sumPercentages) * 100;
      });
    }

    setState(() {
      _genrePopularityMap = genrePopularityMap;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onGenreSelected(_genrePopularityMap);
    });
  }

  Color getGenreColor(String genreName) {
    return Colors.primaries[genreName.length % Colors.primaries.length];
  }

  @override
  Widget build(BuildContext context) {
    return _genrePopularityMap.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: PieChart(
          PieChartData(
            sections: _genrePopularityMap.entries.map((entry) {
              return PieChartSectionData(
                color: getGenreColor(entry.key),
                value: entry.value,
                title: entry.key, // Modification ici
                titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                radius: 100,
              );
            }).toList(),
            borderData: FlBorderData(show: false),
            sectionsSpace: 2,
            centerSpaceRadius: 80,
          ),
        ),
      ),
    )
        : Center(child: CircularProgressIndicator());
  }
}
