import 'package:flutter/material.dart';
import 'fetchService.dart';
import 'genre.dart';
import 'movie.dart';
import 'package:fl_chart/fl_chart.dart';

class piechartPage2 extends StatefulWidget {
  @override
  _piechartPage2State createState() => _piechartPage2State();
}

class _piechartPage2State extends State<piechartPage2> {
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

    print('Movies: $movies'); // Add this line to check the retrieved movies
    print('Genres: $genres');

    Map<String, double> genrePopularityMap = {};
    List<Color> genreColors = [];

    // Retrieve genre popularity and assign colors
    for (var genre in genres) {
      double genrePopularity = await calculateGenrePopularity(movies, genre.id);
      genrePopularityMap[genre.name] = genrePopularity;
      genreColors.add(getGenreColor(genre.name));
    }

    print('Genre Popularity Map: $genrePopularityMap');

    setState(() {
      _genrePopularityMap = genrePopularityMap;
      _genreColors = genreColors;
    });
  }

  Color getGenreColor(String genreName) {
    // Function to get color based on genre name
    // You can use the same logic as the first pie chart
    // or define a predefined list of colors and assign them to genres
    // This function returns a color based on the genre name
    // You can implement your own logic here to assign colors
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
      return 0; // Pour éviter une division par zéro
    }

    double genrePopularityPercentage = (genrePopularity / totalPopularity) * 100;
    print('Genre ID: $genreId, Popularity: $genrePopularityPercentage'); // Ajouter cette ligne pour vérifier la popularité calculée
    return genrePopularityPercentage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pie Chart 2'),
      ),
      body: FutureBuilder(
        future: Future.wait([_moviesFuture, _genresFuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: PieChart(
                PieChartData(
                  sections: _genrePopularityMap.entries.map((entry) {
                    return PieChartSectionData(
                      value: entry.value,
                      title: '${entry.key}\n${entry.value.toStringAsFixed(1)}%', // Include percentage in title
                      color: _genreColors[_genrePopularityMap.keys.toList().indexOf(entry.key)],
                      showTitle: true, // Show title with percentage
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
