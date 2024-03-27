import 'package:flutter/material.dart';
import 'fetchService.dart';
import 'genre.dart';
import 'movie.dart';
import 'package:fl_chart/fl_chart.dart';

class PiechartPage2 extends StatefulWidget {
  @override
  _PiechartPage2State createState() => _PiechartPage2State();
}

class _PiechartPage2State extends State<PiechartPage2> {
  late Future<List<Movie>> _moviesFuture;
  late Future<List<Genre>> _genresFuture;
  late Map<String, double> _genrePopularityMap = {};
  List<Color> _genreColors = [];

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

    Map<String, double> genrePopularityMap = {};
    List<Color> genreColors = [];

    // Retrieve genre popularity and assign colors
    for (var genre in genres) {
      double genrePopularity = await calculateGenrePopularity(movies, genre.id);
      genrePopularityMap[genre.name] = genrePopularity;
      genreColors.add(getGenreColor(genre.name));
    }

    setState(() {
      _genrePopularityMap = genrePopularityMap;
      _genreColors = genreColors;
    });
  }

  Color getGenreColor(String genreName) {
    return Colors.primaries[genreName.length % Colors.primaries.length];
  }

  Future<double> calculateGenrePopularity(List<Movie> movies, int genreId) async {
    double totalPopularity = 0;
    double genrePopularity = 0;

    for (var movie in movies) {
      totalPopularity += movie.popularity;
      if (movie.genreIds.contains(genreId)) {
        genrePopularity += movie.popularity;
      }
    }

    if (totalPopularity == 0) {
      return 0; // To avoid division by zero
    }

    return (genrePopularity / totalPopularity) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Popularity of genre',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: FutureBuilder(
          future: Future.wait([_moviesFuture, _genresFuture]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Image.asset('assets/clap.gif'));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20.0),
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
                                    child:  PieChart(
                                      PieChartData(
                                        sections: _genrePopularityMap.entries.map((entry) {
                                          return PieChartSectionData(
                                            value: entry.value,
                                            title: '${entry.key}',
                                            color: _genreColors[_genrePopularityMap.keys.toList().indexOf(entry.key)],
                                            showTitle: true,
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
                                          show: true,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 7,
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
                               SizedBox(height: 20,),
                                
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    children: _genrePopularityMap.entries.map((entry) {
                                      final title = '${entry.key} (${entry.value.toStringAsFixed(1)}%)';
                                      final color = Colors.primaries[entry.key.length % Colors.primaries.length];

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
