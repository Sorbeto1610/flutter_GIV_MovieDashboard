import 'genre.dart';
import 'movie.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'fetchService.dart';

Map<String, int> countingGenreDictionary(List<Movie> movieList, List<Genre> genreList) {
  Map<String, int> nbGenreDictionary = {};

  for (Movie movie in movieList) {
    for (int idGenre in movie.genreIds) {
      for (Genre genre in genreList) {
        if (idGenre == genre.id) {
          int? count = nbGenreDictionary[genre.name];
          if (count != null) {
            nbGenreDictionary[genre.name] = count + 1;
          } else {
            nbGenreDictionary[genre.name] = 1;
          }
        }
      }
    }
  }

  return nbGenreDictionary;
}

Map<String, double> calculateGenrePercentages(Map<String, int> genreCounts) {
  Map<String, double> percentages = {};
  int totalMovies = genreCounts.values.reduce((a, b) => a + b);

  genreCounts.forEach((genre, count) {
    double percentage = (count / totalMovies) * 100;
    percentages[genre] = percentage;
  });

  return percentages;
}

void main() async {
  List<Movie> movieList = await FetchService.fetchMoviesTrend();
  List<Genre> genreList = await FetchService.fetchMoviesListGenre();


  // Calculate genre counts and percentages
  Map<String, int> genreCounts = countingGenreDictionary(movieList, genreList);
  Map<String, double> genrePercentages = calculateGenrePercentages(genreCounts);


  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Pie Chart Example'),
      ),
      body: Center(
        child: PieChart(
          dataMap: genrePercentages,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32.0,
          chartRadius: 150, // Adjusted to use context
          colorList: Colors.primaries,
          initialAngleInDegree: 0,
          chartType: ChartType.disc,
          ringStrokeWidth: 32,
          centerText: "Genre Distribution",
          legendOptions: LegendOptions(
            showLegendsInRow: true,
            legendPosition: LegendPosition.bottom,
            showLegends: true,
            legendShape: BoxShape.circle,
            legendTextStyle: TextStyle(fontSize: 12),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: false,
          ),
        ),
      ),
    ),
  ));
}
