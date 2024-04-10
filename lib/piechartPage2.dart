import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'ResponsiveText.dart';
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
  late List<Genre> genres; // Déclaration de la liste des genres
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
    genres = await _genresFuture; // Chargement de la liste des genres
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
    int index = genres.indexWhere((genre) => genre.name == genreName);
    return Colors.primaries[index % Colors.primaries.length];
  }

  Future<List<PieChartSectionData>> _buildPieChartSectionData() async {
    Map<String, double> genrePopularityMap = await recupGenrePopularityMap();


    return genrePopularityMap.entries.map((entry) {
      return PieChartSectionData(
        color: getGenreColor(entry.key),
        value: entry.value,
        title: '${(entry.value / 1000).toStringAsFixed(1)}K', // Using entry.key and entry.value from the map
        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: (8*MediaQuery.of(context).size.width+8*MediaQuery.of(context).size.height)/900),
        radius: (12 * MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) / 250 + 35,
      );
    }).toList();
  }

  Future<Map<String, double>> recupGenrePopularityMap() async{
    final List<Movie> movies = await _moviesFuture;
    genres = await _genresFuture; // Chargement de la liste des genres
    Map<String, double> genrePopularityMap = {};
    for (var genre in genres) {
      double genrePopularity = 0;
      for (var movie in movies) {
        if (movie.genreIds.contains(genre.id)) {
          genrePopularity += movie.popularity;
        }
      }

        genrePopularityMap[genre.name] = genrePopularity;
    }
    return genrePopularityMap;
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
        child: Stack(
          children: [
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ResponsiveText(
                  text: 'Cumulated popularity per genre',
                  fontSize: 12,
                  textColor: Colors.white,
                  shadowColor: Colors.white,
                  shadowOffset: Offset(0.0, 0.0),
                ),
              ],
            ),
            FutureBuilder(
              future: _buildPieChartSectionData(),
              builder: (context, snapshot) {

                  return PieChart(
                    PieChartData(
                      startDegreeOffset: -90, // Appliquer la rotation ici
                      sections: snapshot.data as List<PieChartSectionData>,
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: (12 * MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) / 250,
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    )
        : Center(child: CircularProgressIndicator());
  }
}
