import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:giv/ResponsiveText.dart';
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



          final List<Movie> movies = snapshot.data![0];
          final List<Genre> genres = snapshot.data![1];
          genres.sort((a, b) => a.name.compareTo(b.name));
          final Map<String, int> genreCounts = countingGenreDictionary(movies, genres);
          final Map<String, double> genrePercentages = calculateGenrePercentages(genreCounts);
          final sortedGenreCounts = genreCounts.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key));
          final sortedPrimaryColors = sortedGenreCounts.map((entry) {
            final genreIndex = genres.indexWhere((genre) => genre.name == entry.key);
            final colorIndex = genreIndex % Colors.primaries.length;
            return Colors.primaries[colorIndex];
          }).toList();

          bool hasDataChanged = _lastGenrePercentages.toString() != genrePercentages.toString();
          if (hasDataChanged) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onGenreSelected1(genrePercentages);
            });
            _lastGenrePercentages = Map.from(genrePercentages);
          }
          final List<PieChartSectionData> sections = sortedGenreCounts.map((entry) {
            final genreName = entry.key;
            final percentage = genrePercentages[genreName] ?? 0;

            return PieChartSectionData(
              color: sortedPrimaryColors[sortedGenreCounts.indexOf(entry)],
              value: percentage, // Setting value equal to entry.key
              title: '${entry.value}',
              titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: (8*MediaQuery.of(context).size.width+8*MediaQuery.of(context).size.height)/650),
              radius: (12*MediaQuery.of(context).size.width+MediaQuery.of(context).size.height)/250 + 35,
            );
          }).toList();

// Tri des sections en fonction des noms de genre
        sections.sort((a, b) => a.value.compareTo(b.value));


        return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child:
              Stack(
                children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 12,),
                    ResponsiveText(
                      text: 'Quantity of movies per genre',
                      fontSize: 12,
                      textColor: Colors.white,
                      shadowColor: Colors.white,
                      shadowOffset: Offset(0.0, 0.0),
                    ),
                  ],
                  ),


                   PieChart(
                      PieChartData(
                        startDegreeOffset: -90, // Les sections du PieChart sont tournées de -90 degrés
                        sections: sections,
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: (12*MediaQuery.of(context).size.width+MediaQuery.of(context).size.height)/250,
                      ),
                    ),
                ],
              ),
            ),
          );
      },
    );
  }
}
