import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'movie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Popularity Chart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Movie> movieList = [
    Movie(
      title: "Road House",
      popularity: 666.914,
      posterPath: "/bXi6IQiQDHD00JFio5ZSZOeRSBh.jpg",
    ),
    Movie(

      title: "Dune: Part Two",
      popularity: 927.936,
      posterPath: "/8b8R8l88Qje9dn9OE8PY05Nxl1X.jpg",
    ),
    Movie(

      title: "Madame Web",
      popularity: 3250.262,
      posterPath: "/rULWuutDcN5NvtiZi4FRPzRYWSh.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Popularity Chart'),
      ),
      body: Center(
        child: Container(
          height: 400,
          padding: EdgeInsets.all(20.0),
          child: _buildBarChart(),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    final List<charts.Series<Movie, String>> seriesList =
    comparePopularityList(movieList);

    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: true,
    );
  }

  // Fonction pour comparer la popularité des films
  List<charts.Series<Movie, String>> comparePopularityList(List<Movie> movieList) {
    final data = movieList.map((movie) => Movie(
      title: movie.title,
      popularity: movie.popularity,
      posterPath: movie.posterPath,
    )).toList();

    return [
      charts.Series<Movie, String>(
        id: 'Popularity',
        data: data,
        domainFn: (Movie movie, _) => movie.title,
        measureFn: (Movie movie, _) => movie.popularity.toInt(),
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (Movie movie, _) => '${movie.title}: ${movie.popularity}',
      ),
    ];
  }
}
